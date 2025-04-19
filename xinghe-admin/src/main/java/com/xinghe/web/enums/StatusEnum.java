package com.xinghe.web.enums;

import lombok.Getter;

@Getter
public enum StatusEnum {

    /**
     * 草稿
     * 待审批
     * 审批不通过
     * 已立项
     * 待中期检查
     * 已中期检查
     * 待结项
     * 已结项
     */
    DRAFT("草稿"),
    WAIT_APPROVE("待审批"),
    APPROVE_FAIL("审批不通过"),
    APPROVED("已立项"),
    WAIT_MIDDLE_CHECK("待中期检查"),
    MIDDLE_CHECKED("已中期检查"),
    WAIT_FINAL_CHECK("待结项"),
    FINAL_CHECKED("已结项");


    public final String name;

    StatusEnum(String name) {
        this.name = name;
    }

}
