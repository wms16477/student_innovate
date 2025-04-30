package com.xinghe.web.mapper;

import java.util.List;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xinghe.web.domain.School;

/**
 * 学校Mapper接口
 *
 * @date 2025-04-20
 */
public interface SchoolMapper extends BaseMapper<School> {

    /**
     * 查询学校列表
     *
     * @param school 学校
     * @return 学校集合
     */
    List<School> selectList(School school);
} 