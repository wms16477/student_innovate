package com.xinghe.web.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.util.Date;

import com.xinghe.common.annotation.Excel;
import lombok.Data;

/**
 * 专家表
 *
 * @TableName professional
 */
@TableName(value = "professional")
@Data
public class Professional {
    /**
     * id
     */
    @TableId
    private Long id;

    /**
     * 账号
     */
    @Excel(name = "账号")
    private String account;

    /**
     * 专家姓名
     */
    @Excel(name = "姓名")
    private String name;

    /**
     * 领域
     */
    @Excel(name = "领域")
    private String area;

    /**
     * 性别
     */
    @Excel(name = "性别")
    private String gender;

    /**
     * 所属单位
     */
    @Excel(name = "所属单位")
    private String company;

    /**
     * 职务
     */
    @Excel(name = "职务")
    private String job;

    /**
     * 联系方式
     */
    @Excel(name = "联系方式")
    private String phoneNum;

    /**
     * 研究方向
     */
    @Excel(name = "研究方向")
    private String researchDirection;

    /**
     * 创建时间
     */
    private Date createTime;
}
