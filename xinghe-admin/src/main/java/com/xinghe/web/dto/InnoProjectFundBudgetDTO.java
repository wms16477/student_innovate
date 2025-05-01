package com.xinghe.web.dto;

import com.xinghe.web.domain.InnoProjectFundBudget;
import lombok.Data;

/**
 * 经费预算DTO
 */
@Data
public class InnoProjectFundBudgetDTO extends InnoProjectFundBudget {
    
    /**
     * 学校ID（用于数据权限过滤）
     */
    private Long schoolId;
} 