package com.xinghe.web.service;

import java.util.List;

import com.baomidou.mybatisplus.extension.service.IService;
import com.xinghe.web.domain.Teacher;

/**
 * 老师Service接口
 *
 * @author ruoyi
 * @date 2025-04-19
 */
public interface TeacherService extends IService<Teacher> {

    /**
     * 查询老师列表
     *
     * @param teacher 老师
     * @return 老师集合
     */
    List<Teacher> selectList(Teacher teacher);

    /**
     * 新增教师
     */
    void addTeacher(Teacher teacher);

    /**
     * 导入老师数据
     * 
     * @param teacherList 老师数据列表
     * @return 结果
     */
    String importTeachers(List<Teacher> teacherList);
}
