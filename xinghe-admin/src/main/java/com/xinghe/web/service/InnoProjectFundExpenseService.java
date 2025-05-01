package com.xinghe.web.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.xinghe.web.domain.InnoProjectFundExpense;

/**
 * 经费支出Service接口
 * 
 * @author xinghe
 */
public interface InnoProjectFundExpenseService extends IService<InnoProjectFundExpense> {
    
    /**
     * 审批经费支出
     *
     * @param isApprove 是否批准
     * @param expense 经费支出
     * @return 结果
     */
    int approveExpense(boolean isApprove, InnoProjectFundExpense expense);
    
    /**
     * 学校审批经费支出
     *
     * @param isApprove 是否批准
     * @param expense 经费支出
     * @param schoolId 学校ID
     * @return 结果
     */
    int schoolApproveExpense(boolean isApprove, InnoProjectFundExpense expense, Long schoolId);
    
    /**
     * 提交经费支出
     *
     * @param id 经费支出ID
     * @return 结果
     */
    int submitExpense(Long id);
    
    /**
     * 标记为已支付
     *
     * @param id 经费支出ID
     * @return 结果
     */
    int markAsPaid(Long id);
} 