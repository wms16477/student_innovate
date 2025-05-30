package com.xinghe.web.domain;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * 项目经费预算表
 *
 * @TableName inno_project_fund_budget
 */
@TableName(value = "inno_project_fund_budget")
@Data
public class InnoProjectFundBudget {
    /**
     * ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 项目ID
     */
    private Long projectId;

    /**
     * 预算名称
     */
    private String budgetName;

    /**
     * 预算类型(MATERIAL:材料费,TRAVEL:差旅费,MEETING:会议费,PRINT:印刷费,OTHER:其他费用)
     */
    private String budgetType;

    /**
     * 预算金额
     */
    private BigDecimal budgetAmount;

    /**
     * 预算剩余金额
     */
    private BigDecimal remainingAmount;
    
    /**
     * 材料费金额
     */
    private BigDecimal materialAmount;
    
    /**
     * 差旅费金额
     */
    private BigDecimal travelAmount;
    
    /**
     * 会议费金额
     */
    private BigDecimal meetingAmount;
    
    /**
     * 印刷费金额
     */
    private BigDecimal printAmount;
    
    /**
     * 其他费用金额
     */
    private BigDecimal otherAmount;

    /**
     * 预算说明
     */
    private String budgetDesc;

    /**
     * 状态(DRAFT:草稿,SUBMITTED:已提交,APPROVED:已批准,REJECTED:已拒绝)
     */
    private String status;

    /**
     * 审批人
     */
    private String approveBy;

    /**
     * 审批人姓名
     */
    private String approveByName;

    /**
     * 审批时间
     */
    private Date approveTime;

    /**
     * 审批说明
     */
    private String approveDesc;
    
    /**
     * 学校审批人
     */
    private String schoolApproveBy;

    /**
     * 学校审批人姓名
     */
    private String schoolApproveByName;

    /**
     * 学校审批时间
     */
    private Date schoolApproveTime;

    /**
     * 学校审批说明
     */
    private String schoolApproveDesc;

    /**
     * 创建人
     */
    @TableField(fill = FieldFill.INSERT)
    private String createBy;

    /**
     * 创建人姓名
     */
    @TableField(fill = FieldFill.INSERT)
    private String createByName;

    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private Date createTime;

    /**
     * 项目名称（非数据库字段）
     */
    @TableField(exist = false)
    private String projectName;
    
    /**
     * 可操作按钮列表（非数据库字段）
     */
    @TableField(exist = false)
    private List<String> buttonList;
} 