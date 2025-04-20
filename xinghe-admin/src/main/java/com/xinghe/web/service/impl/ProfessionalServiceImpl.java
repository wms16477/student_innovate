package com.xinghe.web.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xinghe.common.core.domain.entity.SysUser;
import com.xinghe.common.exception.ServiceException;
import com.xinghe.common.utils.SecurityUtils;
import com.xinghe.common.utils.StringUtils;
import com.xinghe.system.service.ISysUserService;
import com.xinghe.web.domain.Professional;
import com.xinghe.web.mapper.ProfessionalMapper;
import com.xinghe.web.service.ProfessionalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
* @author aphler
* @description 针对表【professional(专家表)】的数据库操作Service实现
* @createDate 2025-04-20 09:24:03
*/
@Service
public class ProfessionalServiceImpl extends ServiceImpl<ProfessionalMapper, Professional>
    implements ProfessionalService{

    @Autowired
    private ISysUserService userService;

    @Override
    public List<Professional> selectList(Professional professional) {
        return lambdaQuery()
                .like(StringUtils.isNotEmpty(professional.getAccount()), Professional::getAccount, professional.getAccount())
                .like(StringUtils.isNotEmpty(professional.getName()), Professional::getName, professional.getName())
                .like(StringUtils.isNotEmpty(professional.getArea()), Professional::getArea, professional.getArea())
                .list();
    }

    @Override
    public void addProfessional(Professional professional) {
        // 检查账号是否已存在
        List<SysUser> sysUsers = userService.selectUserList(new SysUser());
        List<SysUser> collect = sysUsers.stream()
                .filter(sysUser -> sysUser.getUserName().equals(professional.getAccount()))
                .collect(Collectors.toList());
        if (!collect.isEmpty()) {
            throw new ServiceException("该账号已存在");
        }

        // 保存专家信息
        save(professional);

        // 创建用户账号
        SysUser user = new SysUser();
        user.setUserName(professional.getAccount());
        user.setNickName(professional.getName());
        user.setPassword(SecurityUtils.encryptPassword("123456")); // 默认密码
        user.setStatus("0");
        user.setPostIds(new Long[]{});
        // 角色设置为专家
        user.setRoleIds(new Long[]{102L});
        userService.insertUser(user);
    }
}




