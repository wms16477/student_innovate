package com.xinghe.web.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xinghe.web.domain.InnoProjectFundExpense;
import com.xinghe.web.domain.InnoProjectFundPayment;
import com.xinghe.web.enums.FundStatusEnum;
import com.xinghe.web.mapper.InnoProjectFundPaymentMapper;
import com.xinghe.web.service.InnoProjectFundExpenseService;
import com.xinghe.web.service.InnoProjectFundPaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 经费支付记录Service实现
 * 
 * @author xinghe
 */
@Service
public class InnoProjectFundPaymentServiceImpl extends ServiceImpl<InnoProjectFundPaymentMapper, InnoProjectFundPayment>
        implements InnoProjectFundPaymentService {
    
    @Autowired
    private InnoProjectFundExpenseService expenseService;
    
    /**
     * 支付经费并更新支出状态
     *
     * @param payment 支付记录
     * @return 结果
     */
    @Override
    @Transactional
    public boolean savePaymentAndUpdateExpense(InnoProjectFundPayment payment) {
        // 1. 保存支付记录
        boolean result = save(payment);
        
        // 2. 更新支出状态为已支付
        if (result) {
            expenseService.markAsPaid(payment.getExpenseId());
        }
        
        return result;
    }
} 