package com.xinghe.web.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.xinghe.web.domain.InnoProjectFundPayment;

/**
 * 经费支付记录Service接口
 * 
 * @author xinghe
 */
public interface InnoProjectFundPaymentService extends IService<InnoProjectFundPayment> {
    
    /**
     * 支付经费并更新支出状态
     *
     * @param payment 支付记录
     * @return 结果
     */
    boolean savePaymentAndUpdateExpense(InnoProjectFundPayment payment);
} 