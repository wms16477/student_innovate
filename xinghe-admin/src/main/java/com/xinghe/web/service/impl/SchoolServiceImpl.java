package com.xinghe.web.service.impl;

import java.util.List;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xinghe.common.core.domain.entity.SysUser;
import com.xinghe.common.exception.ServiceException;
import com.xinghe.common.utils.SecurityUtils;
import com.xinghe.common.utils.StringUtils;
import com.xinghe.system.service.ISysUserService;
import com.xinghe.web.constants.Constants;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.xinghe.web.mapper.SchoolMapper;
import com.xinghe.web.domain.School;
import com.xinghe.web.service.SchoolService;

/**
 * 学校Service业务层处理
 *
 * @date 2025-04-20
 */
@Service
public class SchoolServiceImpl extends ServiceImpl<SchoolMapper, School> implements SchoolService {

    @Autowired
    private ISysUserService userService;

    /**
     * 查询学校列表
     *
     * @param school 学校
     * @return 学校
     */
    @Override
    public List<School> selectList(School school) {
        LambdaQueryWrapper<School> queryWrapper = new LambdaQueryWrapper<>();
        if (StringUtils.isNotEmpty(school.getSchoolCode())) {
            queryWrapper.like(School::getSchoolCode, school.getSchoolCode());
        }
        if (StringUtils.isNotEmpty(school.getSchoolName())) {
            queryWrapper.like(School::getSchoolName, school.getSchoolName());
        }
        return this.list(queryWrapper);
    }

    /**
     * 新增学校
     *
     * @param school 学校信息
     */
    @Override
    public void addSchool(School school) {
        // 检查学校编码是否已存在
        LambdaQueryWrapper<School> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(School::getSchoolCode, school.getSchoolCode());
        long count = this.count(queryWrapper);
        if (count > 0) {
            throw new ServiceException("学校编码已存在");
        }
        this.save(school);
        //添加用户
        /**
         * {"userName":"a1","nickName":"appp","password":"123456","status":"0","postIds":[],"roleIds":[100]}
         */
        SysUser user = new SysUser();
        user.setUserName(school.getSchoolCode());
        user.setNickName(school.getSchoolName());
        //获取身份证号后六位
        user.setPassword(SecurityUtils.encryptPassword("123456"));
        user.setStatus("0");
        user.setPostIds(new Long[]{});
        //角色设置成学生
        user.setRoleIds(new Long[]{Constants.SCHOOL_ROLE_ID});
        userService.insertUser(user);
    }
}
