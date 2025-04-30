package com.xinghe.web.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xinghe.common.exception.ServiceException;
import com.xinghe.common.utils.SecurityUtils;
import com.xinghe.web.domain.InnoProjectFundExpense;
import com.xinghe.web.enums.FundStatusEnum;
import com.xinghe.web.mapper.InnoProjectFundExpenseMapper;
import com.xinghe.web.service.InnoProjectFundExpenseService;
import org.springframework.stereotype.Service;

import java.util.Date;

/**
 * 经费支出Service实现
 * 
 * @author xinghe
 */
@Service
public class InnoProjectFundExpenseServiceImpl extends ServiceImpl<InnoProjectFundExpenseMapper, InnoProjectFundExpense>
        implements InnoProjectFundExpenseService {

    /**
     * 审批经费支出
     *
     * @param isApprove 是否批准
     * @param expense 经费支出
     * @return 结果
     */
    @Override
    public int approveExpense(boolean isApprove, InnoProjectFundExpense expense) {
        // 检查状态
        InnoProjectFundExpense db = getById(expense.getId());
        if (db == null) {
            throw new ServiceException("经费支出不存在");
        }
        if (!FundStatusEnum.SUBMITTED.name().equals(db.getStatus())) {
            throw new ServiceException("只有已提交的经费支出才能审批");
        }
        
        // 设置审批信息
        db.setApproveBy(SecurityUtils.getUsername());
        db.setApproveByName(SecurityUtils.getLoginUser().getUser().getNickName());
        db.setApproveTime(new Date());
        db.setApproveDesc(expense.getApproveDesc());
        db.setStatus(isApprove ? FundStatusEnum.APPROVED.name() : FundStatusEnum.REJECTED.name());
        
        return baseMapper.updateById(db);
    }

    /**
     * 提交经费支出
     *
     * @param id 经费支出ID
     * @return 结果
     */
    @Override
    public int submitExpense(Long id) {
        // 检查状态
        InnoProjectFundExpense db = getById(id);
        if (db == null) {
            throw new ServiceException("经费支出不存在");
        }
        if (!FundStatusEnum.DRAFT.name().equals(db.getStatus()) && 
            !FundStatusEnum.REJECTED.name().equals(db.getStatus())) {
            throw new ServiceException("只有草稿或已拒绝的经费支出才能提交");
        }
        
        // 设置状态
        db.setStatus(FundStatusEnum.SUBMITTED.name());
        
        return baseMapper.updateById(db);
    }
    
    /**
     * 标记为已支付
     *
     * @param id 经费支出ID
     * @return 结果
     */
    @Override
    public int markAsPaid(Long id) {
        // 检查状态
        InnoProjectFundExpense db = getById(id);
        if (db == null) {
            throw new ServiceException("经费支出不存在");
        }
        if (!FundStatusEnum.APPROVED.name().equals(db.getStatus())) {
            throw new ServiceException("只有已批准的经费支出才能标记为已支付");
        }
        
        // 设置状态
        db.setStatus(FundStatusEnum.PAID.name());
        
        return baseMapper.updateById(db);
    }
} 