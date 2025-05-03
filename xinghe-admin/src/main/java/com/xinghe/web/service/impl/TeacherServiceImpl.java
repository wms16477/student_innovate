package com.xinghe.web.service.impl;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xinghe.common.core.domain.entity.SysRole;
import com.xinghe.common.core.domain.entity.SysUser;
import com.xinghe.common.exception.ServiceException;
import com.xinghe.common.utils.SecurityUtils;
import com.xinghe.common.utils.StringUtils;
import com.xinghe.system.mapper.SysUserMapper;
import com.xinghe.system.service.ISysUserService;
import com.xinghe.web.constants.Constants;
import com.xinghe.web.domain.School;
import com.xinghe.web.domain.Student;
import com.xinghe.web.service.SchoolService;
import com.xinghe.web.service.StudentService;
import org.aspectj.weaver.ast.Var;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.xinghe.web.mapper.TeacherMapper;
import com.xinghe.web.domain.Teacher;
import com.xinghe.web.service.TeacherService;

/**
 * 老师Service业务层处理
 *
 * @author ruoyi
 * @date 2025-04-19
 */
@Service
public class TeacherServiceImpl extends ServiceImpl<TeacherMapper, Teacher> implements TeacherService {


    @Autowired
    private ISysUserService userService;

    @Autowired
    private SchoolService schoolService;

    @Autowired
    private StudentService studentService;

    @Autowired
    private SysUserMapper sysUserMapper;

    /**
     * 查询老师列表
     *
     * @param teacher 老师
     * @return 老师
     */
    @Override
    public List<Teacher> selectList(Teacher teacher) {
        Optional<SysRole> first = SecurityUtils.getLoginUser().getUser().getRoles().stream().filter(role -> Constants.STU_ROLE_ID.equals(role.getRoleId())).findFirst();
        if (first.isPresent()) {
            teacher.setSchoolId(studentService.lambdaQuery().eq(Student::getStuNo, SecurityUtils.getUsername()).one().getSchoolId());
        }
        LambdaQueryWrapper<Teacher> queryWrapper = new LambdaQueryWrapper<>();
        if (StringUtils.isNotEmpty(teacher.getAccount())) {
            queryWrapper.like(Teacher::getAccount, teacher.getAccount());
        }
        if (StringUtils.isNotEmpty(teacher.getTeacherName())) {
            queryWrapper.like(Teacher::getTeacherName, teacher.getTeacherName());
        }
        if (teacher.getSchoolId() != null) {
            queryWrapper.eq(Teacher::getSchoolId, teacher.getSchoolId());
        }
        return this.list(queryWrapper);
    }

    @Override
    public void addTeacher(Teacher teacher) {
        if (sysUserMapper.countUserCode(teacher.getAccount()) > 0) {
            throw new ServiceException("该学号已有学生");
        }

        // 如果设置了学校ID，则获取学校名称
        if (teacher.getSchoolId() != null) {
            School school = schoolService.getById(teacher.getSchoolId());
            if (school != null) {
                teacher.setSchoolName(school.getSchoolName());
            } else {
                throw new ServiceException("所选学校不存在");
            }
        }

        save(teacher);
        //添加用户
        /**
         * {"userName":"a1","nickName":"appp","password":"123456","status":"0","postIds":[],"roleIds":[100]}
         */
        SysUser user = new SysUser();
        user.setUserName(teacher.getAccount());
        user.setNickName(teacher.getTeacherName());
        user.setPassword(SecurityUtils.encryptPassword("123456"));
        user.setStatus("0");
        user.setPostIds(new Long[]{});
        //角色设置成老师
        user.setRoleIds(new Long[]{101L});
        userService.insertUser(user);
    }

    /**
     * 导入老师数据
     *
     * @param teacherList 老师数据列表
     * @return 结果
     */
    @Override
    public String importTeachers(List<Teacher> teacherList) {
        if (StringUtils.isNull(teacherList) || teacherList.isEmpty()) {
            throw new ServiceException("导入老师数据不能为空！");
        }

        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();

        for (Teacher teacher : teacherList) {
            try {
                // 验证必要字段
                if (StringUtils.isEmpty(teacher.getAccount())) {
                    failureNum++;
                    failureMsg.append("<br/>第 ").append(failureNum).append(" 条数据账号为空");
                    continue;
                }

                if (StringUtils.isEmpty(teacher.getTeacherName())) {
                    failureNum++;
                    failureMsg.append("<br/>第 ").append(failureNum).append(" 条数据老师姓名为空");
                    continue;
                }

                // 根据学校名称查找学校ID
                if (StringUtils.isNotEmpty(teacher.getSchoolName())) {
                    // 只进行完全匹配
                    List<School> exactSchools = schoolService.lambdaQuery()
                            .eq(School::getSchoolName, teacher.getSchoolName().trim())
                            .list();

                    if (!exactSchools.isEmpty()) {
                        // 找到完全匹配的学校
                        teacher.setSchoolId(exactSchools.get(0).getId());
                        teacher.setSchoolName(exactSchools.get(0).getSchoolName());
                    } else {
                        // 没有找到完全匹配的学校，报错
                        failureNum++;
                        failureMsg.append("<br/>第 ").append(successNum + failureNum).append(" 条数据导入失败：未找到完全匹配的学校 [").append(teacher.getSchoolName()).append("]");
                        continue;
                    }
                } else {
                    failureNum++;
                    failureMsg.append("<br/>第 ").append(successNum + failureNum).append(" 条数据导入失败：学校名称为空");
                    continue;
                }

                // 添加教师
                addTeacher(teacher);
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
