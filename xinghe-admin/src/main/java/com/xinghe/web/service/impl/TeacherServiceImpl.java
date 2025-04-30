package com.xinghe.web.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xinghe.common.core.domain.entity.SysUser;
import com.xinghe.common.exception.ServiceException;
import com.xinghe.common.utils.SecurityUtils;
import com.xinghe.common.utils.StringUtils;
import com.xinghe.system.service.ISysUserService;
import com.xinghe.web.domain.School;
import com.xinghe.web.domain.Student;
import com.xinghe.web.service.SchoolService;
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

    /**
     * 查询老师列表
     *
     * @param teacher 老师
     * @return 老师
     */
    @Override
    public List<Teacher> selectList(Teacher teacher) {
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
        List<SysUser> sysUsers = userService.selectUserList(new SysUser());
        List<SysUser> collect = sysUsers.stream().filter(sysUser -> sysUser.getUserName().equals(teacher.getAccount())).collect(Collectors.toList());
        if (!collect.isEmpty()) {
            throw new ServiceException("该账号已被注册");
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
}
