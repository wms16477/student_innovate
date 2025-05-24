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
     * 重写save方法，计算总支出金额
     */
    @Override
    public boolean save(InnoProjectFundExpense entity) {
        // 计算总支出金额
        BigDecimal totalAmount = calculateTotalAmount(entity);
        entity.setExpenseAmount(totalAmount);
        
        // 验证预算是否足够
        validateBudget(entity);
        
        return super.save(entity);
    }
    
    /**
     * 重写updateById方法，计算总支出金额
     */
    @Override
    public boolean updateById(InnoProjectFundExpense entity) {
        // 计算总支出金额
        BigDecimal totalAmount = calculateTotalAmount(entity);
        entity.setExpenseAmount(totalAmount);
        
        // 验证预算是否足够
        validateBudget(entity);
        
        return super.updateById(entity);
    }
    
    /**
     * 计算总支出金额
     */
    private BigDecimal calculateTotalAmount(InnoProjectFundExpense expense) {
        BigDecimal total = BigDecimal.ZERO;
        
        // 将null值转为0
        BigDecimal materialAmount = expense.getMaterialAmount() != null ? expense.getMaterialAmount() : BigDecimal.ZERO;
        BigDecimal travelAmount = expense.getTravelAmount() != null ? expense.getTravelAmount() : BigDecimal.ZERO;
        BigDecimal meetingAmount = expense.getMeetingAmount() != null ? expense.getMeetingAmount() : BigDecimal.ZERO;
        BigDecimal printAmount = expense.getPrintAmount() != null ? expense.getPrintAmount() : BigDecimal.ZERO;
        BigDecimal otherAmount = expense.getOtherAmount() != null ? expense.getOtherAmount() : BigDecimal.ZERO;
        
        total = total.add(materialAmount)
                    .add(travelAmount)
                    .add(meetingAmount)
                    .add(printAmount)
                    .add(otherAmount);
                    
        return total;
    }
    
    /**
     * 验证预算是否足够
     */
    private void validateBudget(InnoProjectFundExpense expense) {
        if (expense.getBudgetId() != null) {
            InnoProjectFundBudget budget = budgetService.getById(expense.getBudgetId());
            if (budget == null) {
                throw new ServiceException("预算不存在");
            }
            
            // 验证各类型金额是否超过预算
            if (expense.getMaterialAmount() != null && expense.getMaterialAmount().compareTo(BigDecimal.ZERO) > 0) {
                if (budget.getMaterialAmount() == null || expense.getMaterialAmount().compareTo(budget.getMaterialAmount()) > 0) {
                    throw new ServiceException("材料费超出预算金额");
                }
            }
            
            if (expense.getTravelAmount() != null && expense.getTravelAmount().compareTo(BigDecimal.ZERO) > 0) {
                if (budget.getTravelAmount() == null || expense.getTravelAmount().compareTo(budget.getTravelAmount()) > 0) {
                    throw new ServiceException("差旅费超出预算金额");
                }
            }
            
            if (expense.getMeetingAmount() != null && expense.getMeetingAmount().compareTo(BigDecimal.ZERO) > 0) {
                if (budget.getMeetingAmount() == null || expense.getMeetingAmount().compareTo(budget.getMeetingAmount()) > 0) {
                    throw new ServiceException("会议费超出预算金额");
                }
            }
            
            if (expense.getPrintAmount() != null && expense.getPrintAmount().compareTo(BigDecimal.ZERO) > 0) {
                if (budget.getPrintAmount() == null || expense.getPrintAmount().compareTo(budget.getPrintAmount()) > 0) {
                    throw new ServiceException("印刷费超出预算金额");
                }
            }
            
            if (expense.getOtherAmount() != null && expense.getOtherAmount().compareTo(BigDecimal.ZERO) > 0) {
                if (budget.getOtherAmount() == null || expense.getOtherAmount().compareTo(budget.getOtherAmount()) > 0) {
                    throw new ServiceException("其他费用超出预算金额");
                }
            }
            
            // 检查总预算金额
            if (expense.getExpenseAmount() != null && expense.getExpenseAmount().compareTo(BigDecimal.ZERO) > 0) {
                if (budget.getRemainingAmount() == null || expense.getExpenseAmount().compareTo(budget.getRemainingAmount()) > 0) {
                    throw new ServiceException("支出总金额超出预算剩余金额");
                }
            }
        }
    }

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
} 