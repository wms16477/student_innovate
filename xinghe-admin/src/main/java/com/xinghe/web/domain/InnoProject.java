package com.xinghe.web.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.util.Date;

import lombok.Data;

/**
 * 大创项目表
 *
 * @TableName inno_project
 */
@TableName(value = "inno_project")
@Data
public class InnoProject {
    /**
     * id
     */
    @TableId
    private Long id;

    /**
     * 项目名
     */
    private String projectName;

    /**
     * 项目类型
     */
    private String projectType;

    /**
     * 项目简介
     */
    private String projectDesc;

    /**
     * 导师
     */
    private Long teacherId;

    /**
     * 导师
     */
    private String teacherName;

    /**
     * 申报材料
     */
    private String submitFileName;

    /**
     * 申报材料
     */
    private String submitFileUrl;

    /**
     * 中期检查附件
     */
    private String midCheckFileName;

    /**
     * 中期检查附件
     */
    private String midCheckFileUrl;

    /**
     * 中期检查说明
     */
    private String midCheckDesc;

    /**
     * 结项成果
     */
    private String endFileName;

    /**
     * 结项成果
     */
    private String endFileUrl;

    /**
     * 结项说明
     */
    private String endDesc;

    /**
     * 状态
     */
    private String status;

    /**
     * 审批描述
     */
    private String approveDesc;

    /**
     * 申报人
     */
    private String createBy;

    /**
     * 申报人
     */
    private String createByName;

    /**
     * 创建时间
     */
    private Date createTime;
}
