package com.xinghe.web.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xinghe.common.exception.ServiceException;
import com.xinghe.common.utils.SecurityUtils;
import com.xinghe.web.domain.InnoProjectFundBudget;
import com.xinghe.web.domain.InnoProjectFundExpense;
import com.xinghe.web.enums.FundStatusEnum;
import com.xinghe.web.mapper.InnoProjectFundBudgetMapper;
import com.xinghe.web.mapper.InnoProjectFundExpenseMapper;
import com.xinghe.web.service.InnoProjectFundBudgetService;
import com.xinghe.web.service.InnoProjectFundExpenseService;
import com.xinghe.web.util.ProjectUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 经费支出Service实现
 * 
 * @author xinghe
 */
@Service
public class InnoProjectFundExpenseServiceImpl extends ServiceImpl<InnoProjectFundExpenseMapper, InnoProjectFundExpense>
        implements InnoProjectFundExpenseService {
        
    @Autowired
    private InnoProjectFundBudgetService budgetService;
    
    @Autowired
    private InnoProjectFundBudgetMapper budgetMapper;

    /**
     * 审批经费支出
     *
     * @param isApprove 是否批准
     * @param expense 经费支出
     * @return 结果
     */
    @Override
    @Transactional
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
        
        // 如果批准，需要扣减预算剩余金额
        if (isApprove && db.getBudgetId() != null) {
            InnoProjectFundBudget budget = budgetService.getById(db.getBudgetId());
            if (budget == null) {
                throw new ServiceException("预算不存在");
            }
            
            // 检查预算剩余金额是否足够
            if (budget.getRemainingAmount().compareTo(db.getExpenseAmount()) < 0) {
                throw new ServiceException("预算剩余金额不足，无法批准支出");
            }
            
            // 扣减预算剩余金额
            budget.setRemainingAmount(budget.getRemainingAmount().subtract(db.getExpenseAmount()));
            budgetService.updateById(budget);
        }
        
        return baseMapper.updateById(db);
    }
    
    /**
     * 学校审批经费支出
     *
     * @param isApprove 是否批准
     * @param expense 经费支出
     * @param schoolId 学校ID
     * @return 结果
     */
    @Override
    @Transactional
    public int schoolApproveExpense(boolean isApprove, InnoProjectFundExpense expense, Long schoolId) {
        // 检查状态
        InnoProjectFundExpense db = getById(expense.getId());
        if (db == null) {
            throw new ServiceException("经费支出不存在");
        }
        
        // 检查是否为相应学校的项目
        Long projectSchoolId = ProjectUtil.getSchoolIdByProjectId(db.getProjectId());
        if (!schoolId.equals(projectSchoolId)) {
            throw new ServiceException("只能审批本校项目的支出");
        }
        
        if (!FundStatusEnum.SUBMITTED.name().equals(db.getStatus())) {
            throw new ServiceException("只有已提交的经费支出才能审批");
        }
        
        // 设置学校审批信息
        db.setSchoolApproveBy(SecurityUtils.getUsername());
        db.setSchoolApproveByName(SecurityUtils.getLoginUser().getUser().getNickName());
        db.setSchoolApproveTime(new Date());
        db.setSchoolApproveDesc(expense.getSchoolApproveDesc());
        db.setStatus(isApprove ? FundStatusEnum.APPROVED.name() : FundStatusEnum.REJECTED.name());
        
        // 如果批准，需要扣减预算剩余金额
        if (isApprove && db.getBudgetId() != null) {
            InnoProjectFundBudget budget = budgetService.getById(db.getBudgetId());
            if (budget == null) {
                throw new ServiceException("预算不存在");
            }
            
            // 检查预算剩余金额是否足够
            if (budget.getRemainingAmount().compareTo(db.getExpenseAmount()) < 0) {
                throw new ServiceException("预算剩余金额不足，无法批准支出");
            }
            
            // 扣减预算剩余金额
            budget.setRemainingAmount(budget.getRemainingAmount().subtract(db.getExpenseAmount()));
            budgetService.updateById(budget);
        }
        
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