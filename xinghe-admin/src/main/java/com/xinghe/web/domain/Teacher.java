package com.xinghe.web.domain;

import java.io.Serializable;
import java.util.Date;

import com.xinghe.common.annotation.Excel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 老师对象 teacher
 *
 * @author ruoyi
 * @date 2025-04-19
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Teacher implements Serializable {
    private static final long serialVersionUID = 1L;

    /**
     * id
     */
    private Long id;

    /**
     * 账号
     */
    @Excel(name = "账号")
    private String account;

    /**
     * 老师姓名
     */
    @Excel(name = "老师姓名")
    private String teacherName;

    /**
     * 性别
     */
    @Excel(name = "性别")
    private String gender;

    /**
     * 级别
     */
    @Excel(name = "级别")
    private String level;

    /**
     * 学历
     */
    @Excel(name = "学历")
    private String degree;

    /**
     * 创建时间
     */
    private Date createTime;


}
