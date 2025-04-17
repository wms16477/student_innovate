package com.xinghe.web.service;

import java.util.List;

import com.baomidou.mybatisplus.extension.service.IService;
import com.xinghe.web.domain .Student;

/**
 * 学生Service接口
 *
 * @author ruoyi
 * @date 2025-04-17
 */
public interface IStudentService extends IService<Student> {

    /**
     * 查询学生列表
     *
     * @param student 学生
     * @return 学生集合
     */
    List<Student> selectList(Student student);

    void addStudent(Student student);
}
