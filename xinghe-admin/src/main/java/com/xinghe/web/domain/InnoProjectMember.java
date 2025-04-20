package com.xinghe.web.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 项目成员
 * @TableName inno_project_member
 */
@TableName(value ="inno_project_member")
@Data
public class InnoProjectMember {
    /**
     * id
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 项目id
     */
    private Long projectId;

    /**
     * 项目成员
     */
    private String memberUserCode;

    /**
     * 项目成员
     */
    private String memberUserName;

    /**
     * 是否是提报人
     */
    private Integer reportFlag;
}