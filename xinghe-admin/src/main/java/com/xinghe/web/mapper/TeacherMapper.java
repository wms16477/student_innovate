package com.xinghe.web.mapper;

import java.util.List;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xinghe.web.domain.Teacher;

/**
 * 老师Mapper接口
 *
 * @author ruoyi
 * @date 2025-04-19
 */
public interface TeacherMapper extends BaseMapper<Teacher> {

    /**
     * 查询老师列表
     *
     * @param teacher 老师
     * @return 老师集合
     */
    //public List<Teacher> selectList(Teacher teacher);

}
