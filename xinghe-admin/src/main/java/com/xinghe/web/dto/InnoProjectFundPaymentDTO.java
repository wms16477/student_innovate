package com.xinghe.web.dto;

import com.xinghe.web.domain.InnoProjectFundPayment;
import lombok.Data;

/**
 * 经费支付记录DTO
 */
@Data
public class InnoProjectFundPaymentDTO extends InnoProjectFundPayment {
    
    /**
     * 学校ID（用于数据权限过滤）
     */
    private Long schoolId;
} 