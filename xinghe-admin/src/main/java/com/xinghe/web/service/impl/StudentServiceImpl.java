package com.xinghe.web.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xinghe.common.core.domain.entity.SysUser;
import com.xinghe.common.exception.ServiceException;
import com.xinghe.common.utils.SecurityUtils;
import com.xinghe.common.utils.StringUtils;
import com.xinghe.system.mapper.SysUserMapper;
import com.xinghe.system.service.ISysUserService;
import com.xinghe.web.domain.School;
import com.xinghe.web.service.SchoolService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import com.xinghe.web.mapper.StudentMapper;
import com.xinghe.web.domain.Student;
import com.xinghe.web.service.StudentService;

/**
 * 学生Service业务层处理
 *
 * @author ruoyi
 * @date 2025-04-17
 */
@Service
public class StudentServiceImpl extends ServiceImpl<StudentMapper, Student> implements StudentService {


    @Autowired
    private ISysUserService userService;

    @Autowired
    private SchoolService schoolService;

    @Autowired
    private SysUserMapper sysUserMapper;


    /**
     * 查询学生列表
     *
     * @param student 学生
     * @return 学生
     */
    @Override
    public List<Student> selectList(Student student, boolean excludeSelf) {
        return lambdaQuery()
                .like(StringUtils.isNotEmpty(student.getStuNo()), Student::getStuNo, student.getStuNo())
                .like(StringUtils.isNotEmpty(student.getStuName()), Student::getStuName, student.getStuName())
                .eq(student.getSpeciality() != null, Student::getSpeciality, student.getSpeciality())
                .eq(student.getSchoolId() != null, Student::getSchoolId, student.getSchoolId())
                .ne(excludeSelf, Student::getStuNo, SecurityUtils.getUsername())
                .list();
    }

    @Override
    public void addStudent(Student student) {

        if (sysUserMapper.countUserCode(student.getStuNo()) > 0) {
            throw new ServiceException("该学号已有学生");
        }

        // 如果设置了学校ID，则获取学校名称
        if (student.getSchoolId() != null) {
            School school = schoolService.getById(student.getSchoolId());
            if (school != null) {
                student.setSchoolName(school.getSchoolName());
            } else {
                throw new ServiceException("所选学校不存在");
            }
        }

        save(student);
        //添加用户
        /**
         * {"userName":"a1","nickName":"appp","password":"123456","status":"0","postIds":[],"roleIds":[100]}
         */
        SysUser user = new SysUser();
        user.setUserName(student.getStuNo());
        user.setNickName(student.getStuName());
        //获取身份证号后六位
        user.setPassword(SecurityUtils.encryptPassword("123456"));
        user.setStatus("0");
        user.setPostIds(new Long[]{});
        //角色设置成学生
        user.setRoleIds(new Long[]{100L});
        userService.insertUser(user);
    }

    /**
     * 导入学生数据
     *
     * @param studentList 学生数据列表
     * @return 结果
     */
    @Override
    public String importStudents(List<Student> studentList) {
        if (StringUtils.isNull(studentList) || studentList.isEmpty()) {
            throw new ServiceException("导入学生数据不能为空！");
        }

        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();

        for (Student student : studentList) {
            try {
                // 验证必要字段
                if (StringUtils.isEmpty(student.getStuNo())) {
                    failureNum++;
                    failureMsg.append("<br/>第 ").append(failureNum).append(" 条数据学号为空");
                    continue;
                }

                if (StringUtils.isEmpty(student.getStuName())) {
                    failureNum++;
                    failureMsg.append("<br/>第 ").append(failureNum).append(" 条数据学生姓名为空");
                    continue;
                }

                // 根据学校名称查找学校ID
                if (StringUtils.isNotEmpty(student.getSchoolName())) {
                    // 只进行完全匹配
                    List<School> exactSchools = schoolService.lambdaQuery()
                            .eq(School::getSchoolName, student.getSchoolName().trim())
                            .list();

                    if (!exactSchools.isEmpty()) {
                        // 找到完全匹配的学校
                        student.setSchoolId(exactSchools.get(0).getId());
                        student.setSchoolName(exactSchools.get(0).getSchoolName());
                    } else {
                        // 没有找到完全匹配的学校，报错
                        failureNum++;
                        failureMsg.append("<br/>第 ").append(successNum + failureNum).append(" 条数据导入失败：未找到完全匹配的学校 [").append(student.getSchoolName()).append("]");
                        continue;
                    }
                } else {
                    failureNum++;
                    failureMsg.append("<br/>第 ").append(successNum + failureNum).append(" 条数据导入失败：学校名称为空");
                    continue;
                }

                // 添加学生
                addStudent(student);
                successNum++;
                successMsg.append("<br/>第 ").append(successNum).append(" 条数据导入成功");
            } catch (Exception e) {
                failureNum++;
                String msg = "<br/>第 " + (successNum + failureNum) + " 条数据导入失败：";
                failureMsg.append(msg).append(e.getMessage());
            }
        }

        if (failureNum > 0) {
            failureMsg.insert(0, "很抱歉，导入失败！共 " + failureNum + " 条数据格式不正确，错误如下：");
            throw new ServiceException(failureMsg.toString());
        } else {
            successMsg.insert(0, "恭喜您，数据已全部导入成功！共 " + successNum + " 条，数据如下：");
        }

        return successMsg.toString();
    }
}
