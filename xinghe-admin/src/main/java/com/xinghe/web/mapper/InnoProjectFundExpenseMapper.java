package com.xinghe.web.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xinghe.web.domain.InnoProjectFundExpense;
import com.xinghe.web.dto.InnoProjectFundExpenseDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 经费支出Mapper接口
 * 
 * @author xinghe
 * @Entity com.xinghe.web.domain.InnoProjectFundExpense
 */
public interface InnoProjectFundExpenseMapper extends BaseMapper<InnoProjectFundExpense> {
    
    /**
     * 查询经费支出列表
     * 
     * @param dto 经费支出DTO
     * @return 经费支出列表
     */
    List<InnoProjectFundExpense> getTableList(@Param("dto") InnoProjectFundExpenseDTO dto);
} 