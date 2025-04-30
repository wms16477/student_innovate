package com.xinghe.web.enums;

/**
 * 支付方式枚举
 */
public enum PaymentMethodEnum {
    CASH("现金"),
    BANK("银行转账"),
    OTHER("其他");

    public final String name;

    PaymentMethodEnum(String name) {
        this.name = name;
    }

    public static String getNameByType(String type) {
        for (PaymentMethodEnum value : PaymentMethodEnum.values()) {
            if (value.name().equals(type)) {
                return value.name;
            }
        }
        return "";
    }
} 