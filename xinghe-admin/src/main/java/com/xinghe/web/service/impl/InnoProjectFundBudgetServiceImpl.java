package com.xinghe.web.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xinghe.common.exception.ServiceException;
import com.xinghe.common.utils.SecurityUtils;
import com.xinghe.web.domain.InnoProjectFundBudget;
import com.xinghe.web.enums.FundStatusEnum;
import com.xinghe.web.mapper.InnoProjectFundBudgetMapper;
import com.xinghe.web.service.InnoProjectFundBudgetService;
import org.springframework.stereotype.Service;

import java.util.Date;

/**
 * 经费预算Service实现
 * 
 * @author xinghe
 */
@Service
public class InnoProjectFundBudgetServiceImpl extends ServiceImpl<InnoProjectFundBudgetMapper, InnoProjectFundBudget>
        implements InnoProjectFundBudgetService {

    /**
     * 审批经费预算
     *
     * @param isApprove 是否批准
     * @param budget 经费预算
     * @return 结果
     */
    @Override
    public int approveBudget(boolean isApprove, InnoProjectFundBudget budget) {
        // 检查状态
        InnoProjectFundBudget db = getById(budget.getId());
        if (db == null) {
            throw new ServiceException("经费预算不存在");
        }
        if (!FundStatusEnum.SUBMITTED.name().equals(db.getStatus())) {
            throw new ServiceException("只有已提交的经费预算才能审批");
        }
        
        // 设置审批信息
        db.setApproveBy(SecurityUtils.getUsername());
        db.setApproveByName(SecurityUtils.getLoginUser().getUser().getNickName());
        db.setApproveTime(new Date());
        db.setApproveDesc(budget.getApproveDesc());
        db.setStatus(isApprove ? FundStatusEnum.APPROVED.name() : FundStatusEnum.REJECTED.name());
        
        return baseMapper.updateById(db);
    }

    /**
     * 提交经费预算
     *
     * @param id 经费预算ID
     * @return 结果
     */
    @Override
    public int submitBudget(Long id) {
        // 检查状态
        InnoProjectFundBudget db = getById(id);
        if (db == null) {
            throw new ServiceException("经费预算不存在");
        }
        if (!FundStatusEnum.DRAFT.name().equals(db.getStatus()) && 
            !FundStatusEnum.REJECTED.name().equals(db.getStatus())) {
            throw new ServiceException("只有草稿或已拒绝的经费预算才能提交");
        }
        
        // 设置状态
        db.setStatus(FundStatusEnum.SUBMITTED.name());
        
        return baseMapper.updateById(db);
    }
} 