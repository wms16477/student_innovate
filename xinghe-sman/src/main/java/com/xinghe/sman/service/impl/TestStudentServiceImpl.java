package com.xinghe.sman.service.impl;

import java.util.List;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.xinghe.sman.mapper.TestStudentMapper;
import com.xinghe.sman.domain.TestStudent;
import com.xinghe.sman.service.ITestStudentService;

/**
 * 测试-学生Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-03-13
 */
@Service
public class TestStudentServiceImpl extends ServiceImpl<TestStudentMapper,TestStudent> implements ITestStudentService
{
    @Autowired
    private TestStudentMapper testStudentMapper;

    /**
     * 查询测试-学生列表
     * 
     * @param testStudent 测试-学生
     * @return 测试-学生
     */
    @Override
    public List<TestStudent> selectList(TestStudent testStudent)
    {
        LambdaQueryWrapper<TestStudent> queryWrapper = new LambdaQueryWrapper<>();

        return this.list(queryWrapper);
    }
}
