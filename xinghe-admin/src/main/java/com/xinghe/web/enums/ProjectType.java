package com.xinghe.web.enums;

import lombok.Getter;

@Getter
public enum ProjectType {

    /**
     * 创新训练项目、创业训练项目、创业实践项目
     */
    INNOVATE("创新训练项目"),
    STARTUP("创业训练项目"),
    PRACTICE("创业实践项目");

    public final String name;

    ProjectType(String name) {
        this.name = name;
    }

}
