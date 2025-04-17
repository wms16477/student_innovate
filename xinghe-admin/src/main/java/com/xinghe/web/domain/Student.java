package com.xinghe.web.domain;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;

import com.xinghe.common.annotation.Excel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 学生对象 student
 *
 * @author ruoyi
 * @date 2025-04-17
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Student implements Serializable {
    private static final long serialVersionUID = 1L;

    /**
     * id
     */
    private Long id;

    /**
     * 学号
     */
    @Excel(name = "学号")
    private String stuNo;

    /**
     * 学生姓名
     */
    @Excel(name = "学生姓名")
    private String stuName;

    /**
     * 专业
     */
    @Excel(name = "专业")
    private String speciality;

    /**
     * 联系电话
     */
    @Excel(name = "联系电话")
    private String phoneNum;

    /**
     * 邮箱
     */
    @Excel(name = "邮箱")
    private String email;

    /**
     * 入学时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "入学时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date inTime;

    /**
     * 身份证号
     */
    @Excel(name = "身份证号")
    private String userId;

    private Date createTime;


}
