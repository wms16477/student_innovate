package com.xinghe.web.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.xinghe.web.domain.InnoProjectFundBudget;

/**
 * 经费预算Service接口
 * 
 * @author xinghe
 */
public interface InnoProjectFundBudgetService extends IService<InnoProjectFundBudget> {
    
    /**
     * 审批经费预算
     *
     * @param isApprove 是否批准
     * @param budget 经费预算
     * @return 结果
     */
    int approveBudget(boolean isApprove, InnoProjectFundBudget budget);
    
    /**
     * 学校审批经费预算
     *
     * @param isApprove 是否批准
     * @param budget 经费预算
     * @param schoolId 学校ID
     * @return 结果
     */
    int schoolApproveBudget(boolean isApprove, InnoProjectFundBudget budget, Long schoolId);
    
    /**
     * 提交经费预算
     *
     * @param id 经费预算ID
     * @return 结果
     */
    int submitBudget(Long id);
} 