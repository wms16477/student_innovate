package com.xinghe.web.enums;

/**
 * 经费状态枚举
 */
public enum FundStatusEnum {
    DRAFT("草稿"),
    SUBMITTED("已提交"),
    APPROVED("已批准"),
    REJECTED("已拒绝"),
    PAID("已支付");

    public final String name;

    FundStatusEnum(String name) {
        this.name = name;
    }

    public static String getNameByType(String type) {
        for (FundStatusEnum value : FundStatusEnum.values()) {
            if (value.name().equals(type)) {
                return value.name;
            }
        }
        return "";
    }
} 