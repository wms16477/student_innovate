package com.xinghe.web.mapper;

import com.xinghe.web.domain.InnoProject;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xinghe.web.dto.InnoProjectDTO;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

/**
 * @author aphler
 * @description 针对表【inno_project(大创项目表)】的数据库操作Mapper
 * @createDate 2025-04-19 17:37:18
 * @Entity com.xinghe.web.domain.InnoProject
 */
public interface InnoProjectMapper extends BaseMapper<InnoProject> {


    List<InnoProject> getTableList(@Param("dto") InnoProjectDTO dto, @Param("userId") Long userId, @Param("userCode") String userCode, @Param("userType") Integer userType, @Param("teacherId") Long teacherId, @Param("projectType") String projectType);

}




