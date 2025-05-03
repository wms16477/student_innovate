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

    @Autowired
    private SysUserMapper sysUserMapper;

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
        if (sysUserMapper.countUserCode(school.getSchoolCode()) > 0) {
            throw new ServiceException("该学号已有学生");
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
        //角色设置成学校
        user.setRoleIds(new Long[]{Constants.SCHOOL_ROLE_ID});
        userService.insertUser(user);
    }

    /**
     * 导入学校数据
     *
     * @param schoolList 学校数据列表
     * @return 结果
     */
    @Override
    public String importSchools(List<School> schoolList) {
        if (StringUtils.isNull(schoolList) || schoolList.isEmpty()) {
            throw new ServiceException("导入学校数据不能为空！");
        }

        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();

        for (School school : schoolList) {
            try {
                // 验证必要字段
                if (StringUtils.isEmpty(school.getSchoolCode())) {
                    failureNum++;
                    failureMsg.append("<br/>第 ").append(failureNum).append(" 条数据学校编码为空");
                    continue;
                }

                if (StringUtils.isEmpty(school.getSchoolName())) {
                    failureNum++;
                    failureMsg.append("<br/>第 ").append(failureNum).append(" 条数据学校名称为空");
                    continue;
                }

                // 添加学校
                addSchool(school);
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
