package com.xinghe.web.core.config;

import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import com.xinghe.common.utils.SecurityUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.Objects;
import java.util.function.Supplier;

@Slf4j
@Component
class MybatisPlusMetaObjectHandler implements MetaObjectHandler {

    @Override
    public void insertFill(MetaObject metaObject) {
        //当前时间
        Date now = new Date();
        //当前用户
        String username = SecurityUtils.getLoginUser().getUsername();
        String nickName = SecurityUtils.getLoginUser().getUser().getNickName();
        String[] getterNames = metaObject.getGetterNames();
        for (String getterName : getterNames) {
            if ("createTime".equals(getterName)) {
                this.strictInsertFill(metaObject, "createTime", Date.class, now);
            }
            if ("updateTime".equals(getterName)) {
                this.strictInsertFill(metaObject, "updateTime", Date.class, now);
            }
            if ("createBy".equals(getterName)) {
                this.strictInsertFill(metaObject, "createBy", String.class, username);
            }
            if ("createByName".equals(getterName)) {
                this.strictInsertFill(metaObject, "createByName", String.class, nickName);
            }
            if ("updateBy".equals(getterName)) {
                this.strictInsertFill(metaObject, "updateBy", String.class, username);
            }
            if ("updateByName".equals(getterName)) {
                this.strictInsertFill(metaObject, "updateByName", String.class, nickName);
            }

        }


//        this.strictInsertFill(metaObject, "createByName", String.class, "张三");
//        metaObject.setValue("createByName", "张三");
//        this.setFieldValByName("create_by", "张三", metaObject);
//        System.out.println("11111111111111");

    }

    @Override
    public void updateFill(MetaObject metaObject) {
        String[] getterNames = metaObject.getGetterNames();
        //当前时间
        Date now = new Date();
        //当前用户
        String username = SecurityUtils.getLoginUser().getUsername();
        String nickName = SecurityUtils.getLoginUser().getUser().getNickName();
        for (String getterName : getterNames) {
            if ("updateTime".equals(getterName)) {
                this.setFieldValByName("updateTime", now, metaObject);
            }
            if ("updateBy".equals(getterName)) {
                this.setFieldValByName("updateBy", username, metaObject);
            }
            if ("updateByName".equals(getterName)) {
                this.setFieldValByName("updateByName", nickName, metaObject);
            }

        }
    }


    @Override
    public MetaObjectHandler strictFillStrategy(MetaObject metaObject, String fieldName, Supplier<?> fieldVal) {
        Object obj = fieldVal.get();
        if (Objects.nonNull(obj)) {
            metaObject.setValue(fieldName, obj);
        }
        return this;
    }

}
