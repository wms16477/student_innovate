package com.xinghe.web.enums;

/**
 * 支出状态枚举
 */
public enum ExpenseStatusEnum {
    DRAFT("草稿"),
    SUBMITTED("已提交"),
    APPROVED("已批准"),
    REJECTED("已拒绝");

    public final String name;

    ExpenseStatusEnum(String name) {
        this.name = name;
    }

    public static String getNameByStatus(String status) {
        for (ExpenseStatusEnum value : ExpenseStatusEnum.values()) {
            if (value.name().equals(status)) {
                return value.name;
            }
        }
        return "";
    }
} 