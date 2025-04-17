package com.xinghe.web.mapper;

import java.util.List;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xinghe.web.domain.Student;

/**
 * 学生Mapper接口
 *
 * @author ruoyi
 * @date 2025-04-17
 */
public interface StudentMapper extends BaseMapper<Student> {

    /**
     * 查询学生列表
     *
     * @param student 学生
     * @return 学生集合
     */
    //public List<Student> selectList(Student student);

}
