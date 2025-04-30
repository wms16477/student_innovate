package com.xinghe.web.domain;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 项目经费支付记录表
 *
 * @TableName inno_project_fund_payment
 */
@TableName(value = "inno_project_fund_payment")
@Data
public class InnoProjectFundPayment {
    /**
     * ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 支出申请ID
     */
    private Long expenseId;

    /**
     * 项目ID
     */
    private Long projectId;

    /**
     * 支付金额
     */
    private BigDecimal paymentAmount;

    /**
     * 支付日期
     */
    private Date paymentDate;

    /**
     * 支付方式(CASH:现金,BANK:银行转账,OTHER:其他)
     */
    private String paymentMethod;

    /**
     * 支付说明
     */
    private String paymentDesc;

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
     * 支出信息（非数据库字段）
     */
    @TableField(exist = false)
    private InnoProjectFundExpense expense;
} 