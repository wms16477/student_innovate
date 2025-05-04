package com.xinghe.web.domain;

import com.xinghe.common.annotation.Excel;
import lombok.Data;

/**
 * 大创项目导入对象
 */
@Data
public class InnoProjectImport {

    /**
     * 项目名称
     */
    @Excel(name = "项目名称")
    private String projectName;

    /**
     * 项目类型
     */
    @Excel(name = "项目类型")
    private String projectType;

    /**
     * 项目简介
     */
    @Excel(name = "项目简介")
    private String projectDesc;

    /**
     * 项目成员(多个成员用逗号分隔)
     */
    @Excel(name = "项目成员(多个成员用逗号分隔)")
    private String members;

    /**
     * 导师姓名
     */
    @Excel(name = "导师")
    private String teacherName;

    /**
     * 申报材料
     * (临时存储上传的文件地址)
     */
    private String submitFileUrl;
}
