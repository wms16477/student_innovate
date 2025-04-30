package com.xinghe.web.service;

import java.util.List;

import com.baomidou.mybatisplus.extension.service.IService;
import com.xinghe.web.domain.School;

/**
 * 学校Service接口
 *
 * @date 2025-04-20
 */
public interface SchoolService extends IService<School> {

    /**
     * 查询学校列表
     *
     * @param school 学校
     * @return 学校集合
     */
    List<School> selectList(School school);

    /**
     * 新增学校
     *
     * @param school 学校
     */
    void addSchool(School school);
} 