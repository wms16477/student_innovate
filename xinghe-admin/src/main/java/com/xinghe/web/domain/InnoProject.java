package com.xinghe.web.domain;

import com.baomidou.mybatisplus.annotation.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import io.swagger.models.auth.In;
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
     * 中期检查-选题价值分
     */
    private Integer midScoreXtjz;


    /**
     * 中期检查-研究基础分
     */
    private Integer midScoreYjjc;

    /**
     * 中期检查-内容设计分
     */
    private Integer midScoreNrsj;

    /**
     * 中期检查-研究方法分
     */
    private Integer midScoreYjff;

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
     * 结项-选题价值分
     */
    private Integer endScoreXtjz;


    /**
     * 结项-研究基础分
     */
    private Integer endScoreYjjc;

    /**
     * 结项-内容设计分
     */
    private Integer endScoreNrsj;

    /**
     * 结项-研究方法分
     */
    private Integer endScoreYjff;

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
    @TableField(fill = FieldFill.INSERT)
    private String createBy;

    /**
     * 申报人
     */
    @TableField(fill = FieldFill.INSERT)
    private String createByName;

    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private Date createTime;

    /**
     * 成员列表
     */
    @TableField(exist = false)
    private List<InnoProjectMember> memberList = new ArrayList<>();

    @TableField(exist = false)
    private List<String> buttonList = new ArrayList<>();


}
