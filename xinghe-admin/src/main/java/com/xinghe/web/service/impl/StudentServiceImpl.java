package com.xinghe.web.service.impl;

import java.util.List;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xinghe.common.core.domain.entity.SysUser;
import com.xinghe.common.exception.ServiceException;
import com.xinghe.common.utils.SecurityUtils;
import com.xinghe.common.utils.StringUtils;
import com.xinghe.system.mapper.SysUserMapper;
import com.xinghe.system.service.ISysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.xinghe.web.mapper.StudentMapper;
import com.xinghe.web.domain.Student;
import com.xinghe.web.service.IStudentService;

/**
 * 学生Service业务层处理
 *
 * @author ruoyi
 * @date 2025-04-17
 */
@Service
public class StudentServiceImpl extends ServiceImpl<StudentMapper, Student> implements IStudentService {


    @Autowired
    private ISysUserService userService;


    /**
     * 查询学生列表
     *
     * @param student 学生
     * @return 学生
     */
    @Override
    public List<Student> selectList(Student student) {
        return lambdaQuery()
                .like(StringUtils.isNotEmpty(student.getStuNo()), Student::getStuNo, student.getStuNo())
                .like(StringUtils.isNotEmpty(student.getStuName()), Student::getStuName, student.getStuName())
                .eq(student.getSpeciality() != null, Student::getSpeciality, student.getSpeciality())
                .list();
    }

    @Override
    public void addStudent(Student student) {
        if (lambdaQuery().eq(Student::getStuNo, student.getStuNo()).count() > 0) {
            throw new ServiceException("改学号已有学生");
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


}
