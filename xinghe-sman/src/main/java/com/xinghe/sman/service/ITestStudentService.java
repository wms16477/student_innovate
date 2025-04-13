package com.xinghe.sman.service;

import java.util.List;
import com.baomidou.mybatisplus.extension.service.IService;
import com.xinghe.sman.domain.TestStudent;

/**
 * 测试-学生Service接口
 * 
 * @author ruoyi
 * @date 2025-03-13
 */
public interface ITestStudentService extends IService<TestStudent>
{

    /**
     * 查询测试-学生列表
     * 
     * @param testStudent 测试-学生
     * @return 测试-学生集合
     */
    public List<TestStudent> selectList(TestStudent testStudent);
}
