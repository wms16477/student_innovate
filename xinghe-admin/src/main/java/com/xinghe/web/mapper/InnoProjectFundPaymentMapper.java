package com.xinghe.web.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xinghe.web.domain.InnoProjectFundPayment;
import com.xinghe.web.dto.InnoProjectFundPaymentDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 经费支付记录Mapper接口
 * 
 * @author xinghe
 * @Entity com.xinghe.web.domain.InnoProjectFundPayment
 */
public interface InnoProjectFundPaymentMapper extends BaseMapper<InnoProjectFundPayment> {
    
    /**
     * 查询经费支付记录列表
     * 
     * @param dto 经费支付记录DTO
     * @return 经费支付记录列表
     */
    List<InnoProjectFundPayment> getTableList(@Param("dto") InnoProjectFundPaymentDTO dto);
} 