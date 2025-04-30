package com.xinghe.web.enum;

/**
 * 经费类型枚举
 */
public enum FundTypeEnum {
    MATERIAL("材料费"),
    TRAVEL("差旅费"),
    MEETING("会议费"),
    PRINT("印刷费"),
    OTHER("其他费用");

    public final String name;

    FundTypeEnum(String name) {
        this.name = name;
    }

    public static String getNameByType(String type) {
        for (FundTypeEnum value : FundTypeEnum.values()) {
            if (value.name().equals(type)) {
                return value.name;
            }
        }
        return "";
    }
} 