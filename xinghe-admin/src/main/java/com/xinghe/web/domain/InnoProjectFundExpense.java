package com.xinghe.web.domain;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * 项目经费支出表
 *
 * @TableName inno_project_fund_expense
 */
@TableName(value = "inno_project_fund_expense")
@Data
public class InnoProjectFundExpense {
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
     * 支出名称
     */
    private String expenseName;

    /**
     * 预算ID
     */
    private Long budgetId;

    /**
     * 支出类型(MATERIAL:材料费,TRAVEL:差旅费,MEETING:会议费,PRINT:印刷费,OTHER:其他费用)
     */
    private String expenseType;

    /**
     * 支出金额
     */
    private BigDecimal expenseAmount;
    
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
     * 支出说明
     */
    private String expenseDesc;

    /**
     * 支出日期
     */
    private Date expenseDate;

    /**
     * 票据附件
     */
    private String fileUrl;

    /**
     * 状态(DRAFT:草稿,SUBMITTED:已提交,APPROVED:已批准,REJECTED:已拒绝,PAID:已支付)
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
     * 预算类型名称（非数据库字段）
     */
    @TableField(exist = false)
    private String budgetTypeName;

    /**
     * 可操作按钮列表（非数据库字段）
     */
    @TableField(exist = false)
    private List<String> buttonList;
} 