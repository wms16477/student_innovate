package com.xinghe.web.dto;

import com.xinghe.web.domain.InnoProjectFundExpense;
import lombok.Data;

/**
 * 经费支出DTO
 */
@Data
public class InnoProjectFundExpenseDTO extends InnoProjectFundExpense {
    
    /**
     * 学校ID（用于数据权限过滤）
     */
    private Long schoolId;
} 