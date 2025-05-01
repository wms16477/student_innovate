package com.xinghe.web.util;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.xinghe.common.exception.ServiceException;
import com.xinghe.web.domain.InnoProject;
import com.xinghe.web.domain.Student;
import com.xinghe.web.mapper.InnoProjectMapper;
import com.xinghe.web.mapper.StudentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 项目工具类
 */
@Component
public class ProjectUtil {

    private static InnoProjectMapper innoProjectMapper;
    
    private static StudentMapper studentMapper;
    
    @Autowired
    public void setInnoProjectMapper(InnoProjectMapper innoProjectMapper) {
        ProjectUtil.innoProjectMapper = innoProjectMapper;
    }
    
    @Autowired
    public void setStudentMapper(StudentMapper studentMapper) {
        ProjectUtil.studentMapper = studentMapper;
    }
    
    /**
     * 根据项目ID获取对应的学校ID
     * 
     * @param projectId 项目ID
     * @return 学校ID
     */
    public static Long getSchoolIdByProjectId(Long projectId) {
        if (projectId == null) {
            throw new ServiceException("项目ID不能为空");
        }
        
        // 获取项目信息
        InnoProject project = innoProjectMapper.selectById(projectId);
        if (project == null) {
            throw new ServiceException("项目不存在");
        }
        
        // 获取项目创建人的学号
        String createBy = project.getCreateBy();
        if (createBy == null) {
            throw new ServiceException("项目创建人信息缺失");
        }
        
        // 根据学号获取学生信息
        LambdaQueryWrapper<Student> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Student::getStuNo, createBy);
        Student student = studentMapper.selectOne(queryWrapper);
        
        if (student == null || student.getSchoolId() == null) {
            throw new ServiceException("无法确定项目所属学校");
        }
        
        return student.getSchoolId();
    }
} 