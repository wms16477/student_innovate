package com.xinghe.web.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.xinghe.web.domain.Professional;

import java.util.List;

/**
 * 专家Service接口
 */
public interface ProfessionalService extends IService<Professional> {
    /**
     * 查询专家列表
     *
     * @param professional 专家
     * @return 专家集合
     */
    List<Professional> selectList(Professional professional);

    /**
     * 新增专家
     *
     * @param professional 专家
     */
    void addProfessional(Professional professional);

    /**
     * 导入专家数据
     * 
     * @param professionalList 专家数据列表
     * @return 结果
     */
    String importProfessionals(List<Professional> professionalList);
}
