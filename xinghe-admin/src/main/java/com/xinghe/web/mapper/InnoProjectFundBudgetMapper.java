package com.xinghe.web.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xinghe.web.domain.InnoProjectFundBudget;
import com.xinghe.web.dto.InnoProjectFundBudgetDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 经费预算Mapper接口
 * 
 * @author xinghe
 * @Entity com.xinghe.web.domain.InnoProjectFundBudget
 */
public interface InnoProjectFundBudgetMapper extends BaseMapper<InnoProjectFundBudget> {
    
    /**
     * 查询经费预算列表
     * 
     * @param dto 经费预算DTO
     * @return 经费预算列表
     */
    List<InnoProjectFundBudget> getTableList(@Param("dto") InnoProjectFundBudgetDTO dto);
} 