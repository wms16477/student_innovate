package com.xinghe.web.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xinghe.common.core.domain.entity.SysUser;
import com.xinghe.common.exception.ServiceException;
import com.xinghe.common.utils.SecurityUtils;
import com.xinghe.common.utils.StringUtils;
import com.xinghe.system.mapper.SysUserMapper;
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

    @Autowired
    SysUserMapper sysUserMapper;

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
        if (sysUserMapper.countUserCode(professional.getAccount()) > 0) {
            throw new ServiceException("该学号已有学生");
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

    /**
     * 导入专家数据
     *
     * @param professionalList 专家数据列表
     * @return 结果
     */
    @Override
    public String importProfessionals(List<Professional> professionalList) {
        if (StringUtils.isNull(professionalList) || professionalList.isEmpty()) {
            throw new ServiceException("导入专家数据不能为空！");
        }

        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();

        for (Professional professional : professionalList) {
            try {
                // 验证必要字段
                if (StringUtils.isEmpty(professional.getAccount())) {
                    failureNum++;
                    failureMsg.append("<br/>第 ").append(failureNum).append(" 条数据账号为空");
                    continue;
                }

                if (StringUtils.isEmpty(professional.getName())) {
                    failureNum++;
                    failureMsg.append("<br/>第 ").append(failureNum).append(" 条数据专家姓名为空");
                    continue;
                }

                // 添加专家
                addProfessional(professional);
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




