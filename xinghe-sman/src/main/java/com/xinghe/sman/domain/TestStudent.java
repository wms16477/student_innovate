package com.xinghe.sman.domain;

import com.xinghe.common.annotation.Excel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 测试-学生对象 test_student
 * 
 * @author ruoyi
 * @date 2025-03-13
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class TestStudent {
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** 姓名 */
    @Excel(name = "姓名")
    private String name;

    /** 年龄 */
    @Excel(name = "年龄")
    private Integer age;


}
