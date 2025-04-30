package com.xinghe.web.enums;

import lombok.Getter;

@Getter
public enum SchoolApproveStatusEnum {

    /**
     * 待审批
     * 审批通过
     * 审批不通过
     */
    WAIT_APPROVE("待审批"),
    APPROVE_SUCCESS("审批通过"),
    APPROVE_FAIL("审批不通过");

    public final String name;

    SchoolApproveStatusEnum(String name) {
        this.name = name;
    }
} 