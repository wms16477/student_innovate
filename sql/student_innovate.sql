/*
 Navicat Premium Data Transfer

 Source Server         : 49.232.240.197-57
 Source Server Type    : MySQL
 Source Server Version : 50744
 Source Host           : 49.232.240.197:3307
 Source Schema         : student_innovate

 Target Server Type    : MySQL
 Target Server Version : 50744
 File Encoding         : 65001

 Date: 24/05/2025 10:33:00
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for QRTZ_BLOB_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_BLOB_TRIGGERS`;
CREATE TABLE `QRTZ_BLOB_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_BLOB_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_BLOB_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_CALENDARS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CALENDARS`;
CREATE TABLE `QRTZ_CALENDARS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '日历信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_CALENDARS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_CRON_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CRON_TRIGGERS`;
CREATE TABLE `QRTZ_CRON_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_CRON_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_CRON_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_FIRED_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_FIRED_TRIGGERS`;
CREATE TABLE `QRTZ_FIRED_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint(13) NOT NULL COMMENT '触发的时间',
  `sched_time` bigint(13) NOT NULL COMMENT '定时器制定的时间',
  `priority` int(11) NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '已触发的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_FIRED_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_JOB_DETAILS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_JOB_DETAILS`;
CREATE TABLE `QRTZ_JOB_DETAILS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '任务详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_JOB_DETAILS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_LOCKS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_LOCKS`;
CREATE TABLE `QRTZ_LOCKS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_LOCKS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_PAUSED_TRIGGER_GRPS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_PAUSED_TRIGGER_GRPS`;
CREATE TABLE `QRTZ_PAUSED_TRIGGER_GRPS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '暂停的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_PAUSED_TRIGGER_GRPS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_SCHEDULER_STATE
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SCHEDULER_STATE`;
CREATE TABLE `QRTZ_SCHEDULER_STATE`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint(13) NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint(13) NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '调度器状态表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_SCHEDULER_STATE
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_SIMPLE_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPLE_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPLE_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint(7) NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint(12) NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint(10) NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPLE_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_SIMPLE_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_SIMPROP_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPROP_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPROP_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int(11) NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int(11) NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint(20) NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint(20) NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPROP_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_SIMPROP_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_TRIGGERS`;
CREATE TABLE `QRTZ_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint(13) NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint(13) NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int(11) NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint(13) NOT NULL COMMENT '开始时间',
  `end_time` bigint(13) NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint(2) NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name`, `job_name`, `job_group`) USING BTREE,
  CONSTRAINT `QRTZ_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `QRTZ_JOB_DETAILS` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '触发器详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (1, 'student', '学生表', NULL, NULL, 'Student', 'crud', 'element-ui', 'com.xinghe.web', 'student', 'student', '学生', 'ruoyi', '0', '/', '{\"parentMenuId\":0}', 'admin', '2025-04-17 08:06:48', '', '2025-04-17 08:11:02', NULL);
INSERT INTO `gen_table` VALUES (2, 'teacher', '老师', NULL, NULL, 'Teacher', 'crud', 'element-ui', 'com.xinghe.web', 'person', 'teacher', '老师', 'ruoyi', '0', '/', '{\"parentMenuId\":0}', 'admin', '2025-04-19 08:45:06', '', '2025-04-19 08:50:26', NULL);
INSERT INTO `gen_table` VALUES (3, 'professional', '专家表', NULL, NULL, 'Professional', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'professional', '专家', 'ruoyi', '0', '/', '{}', 'admin', '2025-04-19 08:47:25', '', '2025-04-19 08:48:03', NULL);
INSERT INTO `gen_table` VALUES (4, 'inno_project', '大创项目表', NULL, NULL, 'InnoProject', 'crud', '', 'com.ruoyi.system', 'system', 'project', '大创项目', 'ruoyi', '0', '/', NULL, 'admin', '2025-04-19 09:12:04', '', NULL, NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint(20) NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int(11) NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (1, 1, 'id', 'id', 'bigint(20)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-04-17 08:06:48', '', '2025-04-17 08:11:02');
INSERT INTO `gen_table_column` VALUES (2, 1, 'stu_no', '学号', 'varchar(50)', 'String', 'stuNo', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-04-17 08:06:48', '', '2025-04-17 08:11:02');
INSERT INTO `gen_table_column` VALUES (3, 1, 'stu_name', '学生姓名', 'varchar(50)', 'String', 'stuName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2025-04-17 08:06:48', '', '2025-04-17 08:11:02');
INSERT INTO `gen_table_column` VALUES (4, 1, 'speciality', '专业', 'varchar(50)', 'String', 'speciality', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-04-17 08:06:48', '', '2025-04-17 08:11:02');
INSERT INTO `gen_table_column` VALUES (5, 1, 'phone_num', '联系电话', 'varchar(20)', 'String', 'phoneNum', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-04-17 08:06:48', '', '2025-04-17 08:11:02');
INSERT INTO `gen_table_column` VALUES (6, 1, 'email', '邮箱', 'varchar(50)', 'String', 'email', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-04-17 08:06:48', '', '2025-04-17 08:11:02');
INSERT INTO `gen_table_column` VALUES (7, 1, 'in_time', '入学时间', 'date', 'Date', 'inTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 7, 'admin', '2025-04-17 08:06:48', '', '2025-04-17 08:11:02');
INSERT INTO `gen_table_column` VALUES (8, 1, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2025-04-17 08:06:48', '', '2025-04-17 08:11:02');
INSERT INTO `gen_table_column` VALUES (9, 1, 'user_id', '身份证号', 'varchar(50)', 'String', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 8, '', '2025-04-17 08:08:03', '', '2025-04-17 08:11:02');
INSERT INTO `gen_table_column` VALUES (10, 2, 'id', 'id', 'bigint(20)', 'Long', 'id', '1', '1', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-04-19 08:45:06', '', '2025-04-19 08:50:26');
INSERT INTO `gen_table_column` VALUES (11, 2, 'account', '账号', 'varchar(30)', 'String', 'account', '0', '0', '1', '1', '0', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-04-19 08:45:06', '', '2025-04-19 08:50:26');
INSERT INTO `gen_table_column` VALUES (12, 2, 'teacher_name', '老师姓名', 'varchar(255)', 'String', 'teacherName', '0', '0', '1', '1', '0', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2025-04-19 08:45:06', '', '2025-04-19 08:50:26');
INSERT INTO `gen_table_column` VALUES (13, 2, 'gender', '性别', 'varchar(20)', 'String', 'gender', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-04-19 08:45:06', '', '2025-04-19 08:50:26');
INSERT INTO `gen_table_column` VALUES (14, 2, 'level', '级别', 'varchar(40)', 'String', 'level', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-04-19 08:45:06', '', '2025-04-19 08:50:26');
INSERT INTO `gen_table_column` VALUES (15, 2, 'degree', '学历', 'varchar(30)', 'String', 'degree', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-04-19 08:45:06', '', '2025-04-19 08:50:27');
INSERT INTO `gen_table_column` VALUES (16, 2, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '0', NULL, NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', '2025-04-19 08:45:06', '', '2025-04-19 08:50:27');
INSERT INTO `gen_table_column` VALUES (17, 3, 'id', 'id', 'bigint(20)', 'Long', 'id', '1', '0', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-04-19 08:47:25', '', '2025-04-19 08:48:03');
INSERT INTO `gen_table_column` VALUES (18, 3, 'account', '账号', 'varchar(30)', 'String', 'account', '0', '0', '1', '1', '0', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-04-19 08:47:25', '', '2025-04-19 08:48:03');
INSERT INTO `gen_table_column` VALUES (19, 3, 'name', '专家姓名', 'varchar(30)', 'String', 'name', '0', '0', '1', '1', '0', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2025-04-19 08:47:25', '', '2025-04-19 08:48:03');
INSERT INTO `gen_table_column` VALUES (20, 3, 'area', '领域', 'varchar(50)', 'String', 'area', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-04-19 08:47:26', '', '2025-04-19 08:48:03');
INSERT INTO `gen_table_column` VALUES (21, 3, 'gender', '性别', 'varchar(30)', 'String', 'gender', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-04-19 08:47:26', '', '2025-04-19 08:48:03');
INSERT INTO `gen_table_column` VALUES (22, 3, 'company', '所属单位', 'varchar(100)', 'String', 'company', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-04-19 08:47:26', '', '2025-04-19 08:48:03');
INSERT INTO `gen_table_column` VALUES (23, 3, 'job', '职务', 'varchar(100)', 'String', 'job', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-04-19 08:47:26', '', '2025-04-19 08:48:03');
INSERT INTO `gen_table_column` VALUES (24, 3, 'phone_num', '联系方式', 'varchar(30)', 'String', 'phoneNum', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-04-19 08:47:26', '', '2025-04-19 08:48:03');
INSERT INTO `gen_table_column` VALUES (25, 3, 'research_direction', '研究方向', 'varchar(1000)', 'String', 'researchDirection', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'textarea', '', 9, 'admin', '2025-04-19 08:47:26', '', '2025-04-19 08:48:03');
INSERT INTO `gen_table_column` VALUES (26, 3, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '0', NULL, NULL, NULL, 'EQ', 'datetime', '', 10, 'admin', '2025-04-19 08:47:26', '', '2025-04-19 08:48:03');
INSERT INTO `gen_table_column` VALUES (27, 4, 'id', 'id', 'bigint(20)', 'Long', 'id', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-04-19 09:12:05', '', '2025-04-19 09:21:13');
INSERT INTO `gen_table_column` VALUES (28, 4, 'project_name', '项目名', 'int(11)', 'Long', 'projectName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-04-19 09:12:05', '', '2025-04-19 09:21:13');
INSERT INTO `gen_table_column` VALUES (29, 4, 'project_type', '项目类型', 'varchar(50)', 'String', 'projectType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2025-04-19 09:12:05', '', '2025-04-19 09:21:13');
INSERT INTO `gen_table_column` VALUES (30, 4, 'project_desc', '项目简介', 'varchar(600)', 'String', 'projectDesc', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 4, 'admin', '2025-04-19 09:12:05', '', '2025-04-19 09:21:13');
INSERT INTO `gen_table_column` VALUES (31, 4, 'teacher_id', '导师', 'bigint(20)', 'Long', 'teacherId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-04-19 09:12:05', '', '2025-04-19 09:21:13');
INSERT INTO `gen_table_column` VALUES (32, 4, 'teacher_name', '导师', 'varchar(30)', 'String', 'teacherName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2025-04-19 09:12:06', '', '2025-04-19 09:21:13');
INSERT INTO `gen_table_column` VALUES (33, 4, 'submit_file_name', '申报材料', 'varchar(500)', 'String', 'submitFileName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'textarea', '', 7, 'admin', '2025-04-19 09:12:06', '', '2025-04-19 09:21:13');
INSERT INTO `gen_table_column` VALUES (34, 4, 'submit_file_url', '申报材料', 'varchar(500)', 'String', 'submitFileUrl', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 8, 'admin', '2025-04-19 09:12:06', '', '2025-04-19 09:21:13');
INSERT INTO `gen_table_column` VALUES (35, 4, 'mid_check_file_name', '中期检查附件', 'varchar(500)', 'String', 'midCheckFileName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'textarea', '', 9, 'admin', '2025-04-19 09:12:07', '', '2025-04-19 09:21:13');
INSERT INTO `gen_table_column` VALUES (36, 4, 'mid_check_file_url', '中期检查附件', 'varchar(500)', 'String', 'midCheckFileUrl', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 10, 'admin', '2025-04-19 09:12:07', '', '2025-04-19 09:21:13');
INSERT INTO `gen_table_column` VALUES (37, 4, 'mid_check_desc', '中期检查说明', 'varchar(500)', 'String', 'midCheckDesc', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 11, 'admin', '2025-04-19 09:12:07', '', '2025-04-19 09:21:13');
INSERT INTO `gen_table_column` VALUES (38, 4, 'end_file_name', '结项成果', 'varchar(500)', 'String', 'endFileName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'textarea', '', 12, 'admin', '2025-04-19 09:12:07', '', '2025-04-19 09:21:13');
INSERT INTO `gen_table_column` VALUES (39, 4, 'end_file_url', '结项成果', 'varchar(500)', 'String', 'endFileUrl', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 13, 'admin', '2025-04-19 09:12:08', '', '2025-04-19 09:21:13');
INSERT INTO `gen_table_column` VALUES (40, 4, 'end_desc', '结项说明', 'int(11)', 'String', 'endDesc', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2025-04-19 09:12:08', '', '2025-04-19 09:21:13');
INSERT INTO `gen_table_column` VALUES (41, 4, 'status', '状态', 'varchar(40)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 15, 'admin', '2025-04-19 09:12:08', '', '2025-04-19 09:21:13');
INSERT INTO `gen_table_column` VALUES (42, 4, 'create_by', '申报人', 'varchar(30)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 16, 'admin', '2025-04-19 09:12:09', '', '2025-04-19 09:21:13');
INSERT INTO `gen_table_column` VALUES (43, 4, 'create_by_name', '申报人', 'varchar(30)', 'String', 'createByName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 17, 'admin', '2025-04-19 09:12:09', '', '2025-04-19 09:21:13');
INSERT INTO `gen_table_column` VALUES (44, 4, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '1', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 18, 'admin', '2025-04-19 09:12:09', '', '2025-04-19 09:21:13');

-- ----------------------------
-- Table structure for inno_project
-- ----------------------------
DROP TABLE IF EXISTS `inno_project`;
CREATE TABLE `inno_project`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `project_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目名',
  `project_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目类型',
  `project_desc` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目简介',
  `teacher_id` bigint(20) NULL DEFAULT NULL COMMENT '导师',
  `teacher_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '导师',
  `submit_file_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '申报材料',
  `submit_file_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '申报材料',
  `mid_check_file_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中期检查附件',
  `mid_check_file_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中期检查附件',
  `mid_check_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中期检查说明',
  `mid_score_xtjz` int(11) NULL DEFAULT NULL COMMENT '中期检查-选题价值分',
  `mid_score_yjjc` int(11) NULL DEFAULT NULL COMMENT '中期检查-研究基础分',
  `mid_score_nrsj` int(11) NULL DEFAULT NULL COMMENT '中期检查-内容设计分',
  `mid_score_yjff` int(11) NULL DEFAULT NULL COMMENT '中期检查-研究方法分',
  `mid_score_total` decimal(10, 2) NULL DEFAULT NULL COMMENT '中期检查总分',
  `end_file_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '结项成果',
  `end_file_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '结项成果',
  `end_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '结项说明',
  `end_score_xtjz` int(11) NULL DEFAULT NULL COMMENT '结项-选题价值分',
  `end_score_yjjc` int(11) NULL DEFAULT NULL COMMENT '结项-研究基础分',
  `end_score_nrsj` int(11) NULL DEFAULT NULL COMMENT '结项-内容设计分',
  `end_score_yjff` int(11) NULL DEFAULT NULL COMMENT '结项-研究方法分',
  `end_score_total` decimal(10, 2) NULL DEFAULT NULL COMMENT '结项总分',
  `score_total` decimal(10, 2) NULL DEFAULT NULL COMMENT '总分',
  `status` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态',
  `approve_desc` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审批描述',
  `create_by` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '申报人',
  `create_by_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '申报人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `school_approve_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学校审批状态',
  `school_approve_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学校审批意见',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '大创项目表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of inno_project
-- ----------------------------
INSERT INTO `inno_project` VALUES (19, 'pro01', '创新训练项目', '简介简介', 8, '教师01', NULL, '/profile/upload/2025/05/05/项目er图_20250505133754A001.png', NULL, NULL, NULL, 100, 100, 100, 32, 93.20, NULL, '/profile/upload/2025/05/24/项目提报流程图_20250524100132A001.png', 'sdf', 100, 100, 32, 100, 66.00, 74.16, '已结项', 'wqer', 'stu01', '学生01', '2025-05-05 13:37:56', '待审批', NULL);
INSERT INTO `inno_project` VALUES (20, 'pro02', '创建训练项目', '黑产繁华处无二', 8, '教师01', NULL, NULL, NULL, '/profile/upload/2025/05/05/功能模块图_20250505143438A001.png', '12313', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '已立项', 'dewq', 'stu01', '学生01', '2025-05-05 14:13:54', '待审批', NULL);

-- ----------------------------
-- Table structure for inno_project_fund_budget
-- ----------------------------
DROP TABLE IF EXISTS `inno_project_fund_budget`;
CREATE TABLE `inno_project_fund_budget`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `project_id` bigint(20) NOT NULL COMMENT '项目ID',
  `budget_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '预算名称',
  `budget_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '预算类型(MATERIAL:材料费,TRAVEL:差旅费,MEETING:会议费,PRINT:印刷费,OTHER:其他费用)',
  `budget_amount` decimal(10, 2) NOT NULL COMMENT '预算金额',
  `remaining_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '预算剩余金额',
  `budget_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '预算说明',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态(DRAFT:草稿,SUBMITTED:已提交,APPROVED:已批准,REJECTED:已拒绝)',
  `approve_by` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审批人',
  `approve_by_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审批人姓名',
  `approve_time` datetime NULL DEFAULT NULL COMMENT '审批时间',
  `approve_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审批说明',
  `create_by` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_by_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `school_approve_by` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学校审批人',
  `school_approve_by_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学校审批人姓名',
  `school_approve_time` datetime NULL DEFAULT NULL COMMENT '学校审批时间',
  `school_approve_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学校审批说明',
  `material_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '材料费金额',
  `travel_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '差旅费金额',
  `meeting_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '会议费金额',
  `print_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '印刷费金额',
  `other_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其他费用金额',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project_id`(`project_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '项目经费预算表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inno_project_fund_budget
-- ----------------------------
INSERT INTO `inno_project_fund_budget` VALUES (5, 19, '123', 'TRAVEL', 1230.00, 1107.00, NULL, 'APPROVED', NULL, NULL, NULL, NULL, 'tea01', '教师01', '2025-05-05 14:37:05', 'qhdx', '清华大学', '2025-05-05 14:37:14', '123', 0.00, 1230.00, 0.00, 0.00, 0.00);
INSERT INTO `inno_project_fund_budget` VALUES (6, 19, '测试预算', NULL, 700.00, 100.00, 'efewf', 'APPROVED', NULL, NULL, NULL, NULL, 'tea01', '教师01', '2025-05-24 09:34:06', 'qhdx', '清华大学', '2025-05-24 09:35:59', 'GGGGKJJK', 300.00, 100.00, 100.00, 100.00, 100.00);

-- ----------------------------
-- Table structure for inno_project_fund_expense
-- ----------------------------
DROP TABLE IF EXISTS `inno_project_fund_expense`;
CREATE TABLE `inno_project_fund_expense`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `project_id` bigint(20) NOT NULL COMMENT '项目ID',
  `expense_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支出名称',
  `budget_id` bigint(20) NULL DEFAULT NULL COMMENT '预算ID',
  `expense_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支出类型(MATERIAL:材料费,TRAVEL:差旅费,MEETING:会议费,PRINT:印刷费,OTHER:其他费用)',
  `expense_amount` decimal(10, 2) NOT NULL COMMENT '支出金额',
  `expense_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支出说明',
  `expense_date` date NULL DEFAULT NULL COMMENT '支出日期',
  `file_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '票据附件',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态(DRAFT:草稿,SUBMITTED:已提交,APPROVED:已批准,REJECTED:已拒绝,PAID:已支付)',
  `approve_by` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审批人',
  `approve_by_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审批人姓名',
  `approve_time` datetime NULL DEFAULT NULL COMMENT '审批时间',
  `approve_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审批说明',
  `create_by` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_by_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `school_approve_by` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学校审批人',
  `school_approve_by_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学校审批人姓名',
  `school_approve_time` datetime NULL DEFAULT NULL COMMENT '学校审批时间',
  `school_approve_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学校审批说明',
  `material_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '材料费金额',
  `travel_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '差旅费金额',
  `meeting_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '会议费金额',
  `print_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '印刷费金额',
  `other_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其他费用金额',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project_id`(`project_id`) USING BTREE,
  INDEX `idx_budget_id`(`budget_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '项目经费支出表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inno_project_fund_expense
-- ----------------------------
INSERT INTO `inno_project_fund_expense` VALUES (15, 19, 'werwe', 5, 'TRAVEL', 123.00, '123', '2025-04-29', 'http://localhost:8080/profile/upload/2025/05/05/功能模块图_20250505143803A002.png', 'APPROVED', NULL, NULL, NULL, NULL, 'tea01', '教师01', '2025-05-05 14:38:07', 'qhdx', '清华大学', '2025-05-05 14:39:34', 'qw', 0.00, 123.00, 0.00, 0.00, 0.00);
INSERT INTO `inno_project_fund_expense` VALUES (16, 19, '测试支出', 6, NULL, 600.00, NULL, '2025-05-23', NULL, 'APPROVED', NULL, NULL, NULL, NULL, 'tea01', '教师01', '2025-05-24 09:36:47', 'qhdx', '清华大学', '2025-05-24 09:37:02', 'efws', 300.00, 100.00, 100.00, 100.00, 0.00);

-- ----------------------------
-- Table structure for inno_project_member
-- ----------------------------
DROP TABLE IF EXISTS `inno_project_member`;
CREATE TABLE `inno_project_member`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `project_id` bigint(20) NULL DEFAULT NULL COMMENT '项目id',
  `member_user_code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目成员',
  `member_user_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目成员',
  `report_flag` tinyint(4) NOT NULL DEFAULT 0 COMMENT '是否是提报人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '项目成员' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of inno_project_member
-- ----------------------------
INSERT INTO `inno_project_member` VALUES (19, 19, 'stu02', '学生02', 0);
INSERT INTO `inno_project_member` VALUES (20, 20, 'stu01', '学生01', 0);

-- ----------------------------
-- Table structure for professional
-- ----------------------------
DROP TABLE IF EXISTS `professional`;
CREATE TABLE `professional`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `account` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '账号',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '专家姓名',
  `area` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '领域',
  `gender` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '性别',
  `company` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属单位',
  `job` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '职务',
  `phone_num` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  `research_direction` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '研究方向',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '专家表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of professional
-- ----------------------------
INSERT INTO `professional` VALUES (6, 'p01', '专家01', '创新训练项目', '男', '123', '123', '123', '1232131', '2025-05-05 05:36:17');

-- ----------------------------
-- Table structure for project_flow
-- ----------------------------
DROP TABLE IF EXISTS `project_flow`;
CREATE TABLE `project_flow`  (
  `id` bigint(20) NULL DEFAULT NULL COMMENT 'id',
  `flow_name` int(11) NULL DEFAULT NULL COMMENT '流程名'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '项目流程' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of project_flow
-- ----------------------------

-- ----------------------------
-- Table structure for school
-- ----------------------------
DROP TABLE IF EXISTS `school`;
CREATE TABLE `school`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `school_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '学校编码',
  `school_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '学校名称',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学校地址',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `create_by` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_by_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人姓名',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学校表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of school
-- ----------------------------
INSERT INTO `school` VALUES (4, 'qhdx', '清华大学', '北京', '23131321', NULL, NULL, '2025-05-05 05:23:55');
INSERT INTO `school` VALUES (5, 'bjdx', '北京大学', '北京', '12312312', NULL, NULL, '2025-05-05 05:24:27');

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `stu_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学号',
  `stu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学生姓名',
  `speciality` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '专业',
  `phone_num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `in_time` date NULL DEFAULT NULL COMMENT '入学时间',
  `user_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `school_id` bigint(20) NULL DEFAULT NULL COMMENT '学校ID',
  `school_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学校',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学生表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES (17, 'stu01', '学生01', '计算机科学与技术', '1231', '1231', '2025-05-06', '123', 4, '清华大学', '2025-05-05 05:31:13');
INSERT INTO `student` VALUES (18, 'stu02', '学生02', '计算机', '123', '123', '2023-03-03', '123', 5, '北京大学', '2025-05-05 05:33:50');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int(5) NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2025-04-12 10:31:37', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2025-04-12 10:31:37', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2025-04-12 10:31:37', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2025-04-12 10:31:37', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2025-04-12 10:31:37', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2025-04-12 10:31:37', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-04-12 10:31:23', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-04-12 10:31:23', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-04-12 10:31:23', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-04-12 10:31:23', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-04-12 10:31:23', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-04-12 10:31:23', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-04-12 10:31:23', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-04-12 10:31:23', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-04-12 10:31:23', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-04-12 10:31:23', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int(4) NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2025-04-12 10:31:36', '', NULL, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2025-04-12 10:31:35', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2025-04-12 10:31:35', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2025-04-12 10:31:35', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2025-04-12 10:31:35', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2025-04-12 10:31:35', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2025-04-12 10:31:35', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2025-04-12 10:31:35', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2025-04-12 10:31:35', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2025-04-12 10:31:35', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2025-04-12 10:31:35', '', NULL, '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时任务调度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2025-04-12 10:31:38', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2025-04-12 10:31:38', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2025-04-12 10:31:39', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status`) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 556 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-12 10:46:23');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-12 11:23:14');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-12 11:23:14');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-12 11:23:19');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-13 01:14:03');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-13 03:08:22');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-13 03:08:29');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-17 07:40:39');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-17 09:15:00');
INSERT INTO `sys_logininfor` VALUES (109, '190337772', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-17 09:15:05');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-17 09:16:16');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-17 09:16:48');
INSERT INTO `sys_logininfor` VALUES (112, '123123123', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-17 09:16:58');
INSERT INTO `sys_logininfor` VALUES (113, '123123123', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-04-17 09:22:47');
INSERT INTO `sys_logininfor` VALUES (114, '123123123', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-17 09:22:52');
INSERT INTO `sys_logininfor` VALUES (115, '123123123', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-17 09:22:55');
INSERT INTO `sys_logininfor` VALUES (116, '123123123', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-17 09:23:24');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-18 09:01:24');
INSERT INTO `sys_logininfor` VALUES (118, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-19 06:03:47');
INSERT INTO `sys_logininfor` VALUES (119, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-19 07:42:29');
INSERT INTO `sys_logininfor` VALUES (120, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-19 09:04:49');
INSERT INTO `sys_logininfor` VALUES (121, 'teacher1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-19 09:04:54');
INSERT INTO `sys_logininfor` VALUES (122, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-19 09:05:53');
INSERT INTO `sys_logininfor` VALUES (123, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-19 09:07:42');
INSERT INTO `sys_logininfor` VALUES (124, 'teacher1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-19 09:07:49');
INSERT INTO `sys_logininfor` VALUES (125, 'teacher1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-19 09:08:20');
INSERT INTO `sys_logininfor` VALUES (126, 'aphler', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-19 09:09:02');
INSERT INTO `sys_logininfor` VALUES (127, 'aphler', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-19 09:09:10');
INSERT INTO `sys_logininfor` VALUES (128, 'aphler', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-19 09:09:14');
INSERT INTO `sys_logininfor` VALUES (129, 'teacher1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-19 09:09:26');
INSERT INTO `sys_logininfor` VALUES (130, 'teacher1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-19 09:11:03');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-19 09:11:10');
INSERT INTO `sys_logininfor` VALUES (132, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-04-19 09:51:34');
INSERT INTO `sys_logininfor` VALUES (133, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-19 09:51:41');
INSERT INTO `sys_logininfor` VALUES (134, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-19 09:59:41');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-19 10:03:58');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-20 00:10:00');
INSERT INTO `sys_logininfor` VALUES (137, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-20 00:10:04');
INSERT INTO `sys_logininfor` VALUES (138, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-20 00:10:07');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-20 01:30:17');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-20 01:30:42');
INSERT INTO `sys_logininfor` VALUES (141, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-20 01:30:45');
INSERT INTO `sys_logininfor` VALUES (142, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-20 02:03:38');
INSERT INTO `sys_logininfor` VALUES (143, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-20 02:14:35');
INSERT INTO `sys_logininfor` VALUES (144, 'p2', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-20 02:14:41');
INSERT INTO `sys_logininfor` VALUES (145, 'p2', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-20 02:14:50');
INSERT INTO `sys_logininfor` VALUES (146, 'p2', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-20 02:15:00');
INSERT INTO `sys_logininfor` VALUES (147, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-20 02:15:06');
INSERT INTO `sys_logininfor` VALUES (148, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-20 02:16:33');
INSERT INTO `sys_logininfor` VALUES (149, 'p2', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-20 02:16:39');
INSERT INTO `sys_logininfor` VALUES (150, 'p2', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-20 02:16:50');
INSERT INTO `sys_logininfor` VALUES (151, 'p1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-20 02:16:59');
INSERT INTO `sys_logininfor` VALUES (152, 'p1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-20 02:17:19');
INSERT INTO `sys_logininfor` VALUES (153, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-20 02:17:29');
INSERT INTO `sys_logininfor` VALUES (154, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-20 03:00:36');
INSERT INTO `sys_logininfor` VALUES (155, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-20 05:27:44');
INSERT INTO `sys_logininfor` VALUES (156, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-20 06:09:31');
INSERT INTO `sys_logininfor` VALUES (157, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-20 06:09:47');
INSERT INTO `sys_logininfor` VALUES (158, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-20 08:01:31');
INSERT INTO `sys_logininfor` VALUES (159, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-20 08:01:34');
INSERT INTO `sys_logininfor` VALUES (160, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-20 08:01:35');
INSERT INTO `sys_logininfor` VALUES (161, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-20 08:01:45');
INSERT INTO `sys_logininfor` VALUES (162, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-20 12:23:59');
INSERT INTO `sys_logininfor` VALUES (163, 'p1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-20 12:24:13');
INSERT INTO `sys_logininfor` VALUES (164, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-21 09:25:15');
INSERT INTO `sys_logininfor` VALUES (165, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-21 09:36:33');
INSERT INTO `sys_logininfor` VALUES (166, '12312313112', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-21 09:36:40');
INSERT INTO `sys_logininfor` VALUES (167, '12312313112', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-21 09:36:50');
INSERT INTO `sys_logininfor` VALUES (168, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-21 09:37:01');
INSERT INTO `sys_logininfor` VALUES (169, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-21 09:37:05');
INSERT INTO `sys_logininfor` VALUES (170, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-21 09:37:18');
INSERT INTO `sys_logininfor` VALUES (171, '123123123', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-21 09:37:25');
INSERT INTO `sys_logininfor` VALUES (172, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-21 09:37:29');
INSERT INTO `sys_logininfor` VALUES (173, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-21 09:37:33');
INSERT INTO `sys_logininfor` VALUES (174, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-21 09:37:36');
INSERT INTO `sys_logininfor` VALUES (175, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-21 09:38:59');
INSERT INTO `sys_logininfor` VALUES (176, '19036275', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-21 09:39:14');
INSERT INTO `sys_logininfor` VALUES (177, '19036275', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-21 09:39:24');
INSERT INTO `sys_logininfor` VALUES (178, '19036275', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-21 09:39:33');
INSERT INTO `sys_logininfor` VALUES (179, '19036275', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-21 09:39:38');
INSERT INTO `sys_logininfor` VALUES (180, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-21 10:57:22');
INSERT INTO `sys_logininfor` VALUES (181, '19036275', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-21 11:00:26');
INSERT INTO `sys_logininfor` VALUES (182, 'admin', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 11:13:54');
INSERT INTO `sys_logininfor` VALUES (183, 'admin', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码已失效', '2025-04-21 11:15:14');
INSERT INTO `sys_logininfor` VALUES (184, 'admin', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 11:15:25');
INSERT INTO `sys_logininfor` VALUES (185, 'admin', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 11:29:04');
INSERT INTO `sys_logininfor` VALUES (186, '11111111', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-21 11:29:23');
INSERT INTO `sys_logininfor` VALUES (187, '11111111', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 11:30:07');
INSERT INTO `sys_logininfor` VALUES (188, '11111111', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 11:33:31');
INSERT INTO `sys_logininfor` VALUES (189, '22222222', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 11:33:46');
INSERT INTO `sys_logininfor` VALUES (190, '22222222', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 11:34:03');
INSERT INTO `sys_logininfor` VALUES (191, '33333333', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2025-04-21 11:34:15');
INSERT INTO `sys_logininfor` VALUES (192, '33333333', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 11:34:22');
INSERT INTO `sys_logininfor` VALUES (193, '33333333', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 11:34:34');
INSERT INTO `sys_logininfor` VALUES (194, '44444444', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 11:34:48');
INSERT INTO `sys_logininfor` VALUES (195, '44444444', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 11:35:20');
INSERT INTO `sys_logininfor` VALUES (196, '55555555', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 11:35:34');
INSERT INTO `sys_logininfor` VALUES (197, '55555555', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 11:35:58');
INSERT INTO `sys_logininfor` VALUES (198, '66666666', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 11:36:40');
INSERT INTO `sys_logininfor` VALUES (199, '66666666', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 11:38:10');
INSERT INTO `sys_logininfor` VALUES (200, '77777777', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2025-04-21 11:38:25');
INSERT INTO `sys_logininfor` VALUES (201, '77777777', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 11:38:31');
INSERT INTO `sys_logininfor` VALUES (202, '77777777', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 11:38:49');
INSERT INTO `sys_logininfor` VALUES (203, 'admin', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-21 11:39:05');
INSERT INTO `sys_logininfor` VALUES (204, 'admin', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-21 11:39:22');
INSERT INTO `sys_logininfor` VALUES (205, 'admin', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2025-04-21 11:39:44');
INSERT INTO `sys_logininfor` VALUES (206, 'admin', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-21 11:39:51');
INSERT INTO `sys_logininfor` VALUES (207, 'admin', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-21 11:40:05');
INSERT INTO `sys_logininfor` VALUES (208, 'admin', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 11:41:29');
INSERT INTO `sys_logininfor` VALUES (209, 'admin', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 11:47:28');
INSERT INTO `sys_logininfor` VALUES (210, '44444444', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 11:49:13');
INSERT INTO `sys_logininfor` VALUES (211, '44444444', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 11:52:25');
INSERT INTO `sys_logininfor` VALUES (212, '11111111', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 11:52:56');
INSERT INTO `sys_logininfor` VALUES (213, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-21 12:05:06');
INSERT INTO `sys_logininfor` VALUES (214, '11111111', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-21 12:05:21');
INSERT INTO `sys_logininfor` VALUES (215, '11111111', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:14:20');
INSERT INTO `sys_logininfor` VALUES (216, '22222222', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:14:34');
INSERT INTO `sys_logininfor` VALUES (217, '22222222', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:15:39');
INSERT INTO `sys_logininfor` VALUES (218, '33333333', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:15:49');
INSERT INTO `sys_logininfor` VALUES (219, '33333333', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:16:13');
INSERT INTO `sys_logininfor` VALUES (220, '44444444', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:16:26');
INSERT INTO `sys_logininfor` VALUES (221, '11111111', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-21 12:16:35');
INSERT INTO `sys_logininfor` VALUES (222, '22222222', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-21 12:17:04');
INSERT INTO `sys_logininfor` VALUES (223, '44444444', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:17:45');
INSERT INTO `sys_logininfor` VALUES (224, '44444444', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:27:54');
INSERT INTO `sys_logininfor` VALUES (225, '44444444', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:28:23');
INSERT INTO `sys_logininfor` VALUES (226, '55555555', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:28:41');
INSERT INTO `sys_logininfor` VALUES (227, '55555555', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:29:14');
INSERT INTO `sys_logininfor` VALUES (228, '22222222', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:29:38');
INSERT INTO `sys_logininfor` VALUES (229, '22222222', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:30:47');
INSERT INTO `sys_logininfor` VALUES (230, '33333333', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:31:11');
INSERT INTO `sys_logininfor` VALUES (231, '33333333', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:31:51');
INSERT INTO `sys_logininfor` VALUES (232, '11111111', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:32:03');
INSERT INTO `sys_logininfor` VALUES (233, '11111111', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:33:17');
INSERT INTO `sys_logininfor` VALUES (234, '66666666', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2025-04-21 12:33:30');
INSERT INTO `sys_logininfor` VALUES (235, '66666666', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:33:38');
INSERT INTO `sys_logininfor` VALUES (236, '66666666', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:35:24');
INSERT INTO `sys_logininfor` VALUES (237, '11111111', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:35:39');
INSERT INTO `sys_logininfor` VALUES (238, '11111111', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:37:49');
INSERT INTO `sys_logininfor` VALUES (239, '11111111', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:38:15');
INSERT INTO `sys_logininfor` VALUES (240, '11111111', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:38:39');
INSERT INTO `sys_logininfor` VALUES (241, '66666666', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2025-04-21 12:38:50');
INSERT INTO `sys_logininfor` VALUES (242, '66666666', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:38:55');
INSERT INTO `sys_logininfor` VALUES (243, '66666666', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:39:25');
INSERT INTO `sys_logininfor` VALUES (244, '11111111', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:39:34');
INSERT INTO `sys_logininfor` VALUES (245, '11111111', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:39:55');
INSERT INTO `sys_logininfor` VALUES (246, '66666666', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:40:15');
INSERT INTO `sys_logininfor` VALUES (247, '22222222', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-21 12:40:49');
INSERT INTO `sys_logininfor` VALUES (248, '66666666', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-21 12:41:01');
INSERT INTO `sys_logininfor` VALUES (249, '66666666', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:44:12');
INSERT INTO `sys_logininfor` VALUES (250, '11111111', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:44:24');
INSERT INTO `sys_logininfor` VALUES (251, '66666666', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-21 12:45:36');
INSERT INTO `sys_logininfor` VALUES (252, '11111111', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-21 12:45:43');
INSERT INTO `sys_logininfor` VALUES (253, '11111111', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:52:39');
INSERT INTO `sys_logininfor` VALUES (254, '22222222', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:53:09');
INSERT INTO `sys_logininfor` VALUES (255, '22222222', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:53:58');
INSERT INTO `sys_logininfor` VALUES (256, '33333333', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:54:13');
INSERT INTO `sys_logininfor` VALUES (257, '33333333', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:54:20');
INSERT INTO `sys_logininfor` VALUES (258, '44444444', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:54:37');
INSERT INTO `sys_logininfor` VALUES (259, '44444444', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:55:09');
INSERT INTO `sys_logininfor` VALUES (260, '55555555', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:55:22');
INSERT INTO `sys_logininfor` VALUES (261, '55555555', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:56:00');
INSERT INTO `sys_logininfor` VALUES (262, '11111111', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:56:20');
INSERT INTO `sys_logininfor` VALUES (263, '11111111', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:56:44');
INSERT INTO `sys_logininfor` VALUES (264, '22222222', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:56:55');
INSERT INTO `sys_logininfor` VALUES (265, '22222222', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:57:17');
INSERT INTO `sys_logininfor` VALUES (266, '66666666', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:57:31');
INSERT INTO `sys_logininfor` VALUES (267, '66666666', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2025-04-21 12:57:54');
INSERT INTO `sys_logininfor` VALUES (268, '7777777', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-21 12:58:18');
INSERT INTO `sys_logininfor` VALUES (269, '77777777', '192.168.0.24', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2025-04-21 12:58:29');
INSERT INTO `sys_logininfor` VALUES (270, '11111111', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-21 12:59:48');
INSERT INTO `sys_logininfor` VALUES (271, '11111111', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-21 13:03:25');
INSERT INTO `sys_logininfor` VALUES (272, '11111111', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-21 13:03:29');
INSERT INTO `sys_logininfor` VALUES (273, '11111111', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-21 13:07:21');
INSERT INTO `sys_logininfor` VALUES (274, '66666666', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-21 13:07:31');
INSERT INTO `sys_logininfor` VALUES (275, '11111111', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-22 00:13:19');
INSERT INTO `sys_logininfor` VALUES (276, '11111111', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-22 00:17:37');
INSERT INTO `sys_logininfor` VALUES (277, '44444444', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-22 00:17:46');
INSERT INTO `sys_logininfor` VALUES (278, '44444444', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-22 00:18:13');
INSERT INTO `sys_logininfor` VALUES (279, '11111111', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-22 00:18:22');
INSERT INTO `sys_logininfor` VALUES (280, '11111111', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-22 00:18:36');
INSERT INTO `sys_logininfor` VALUES (281, '44444444', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-22 00:18:45');
INSERT INTO `sys_logininfor` VALUES (282, '44444444', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-22 00:22:26');
INSERT INTO `sys_logininfor` VALUES (283, '11111111', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-22 00:22:36');
INSERT INTO `sys_logininfor` VALUES (284, '11111111', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-22 00:28:13');
INSERT INTO `sys_logininfor` VALUES (285, '66666666', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-22 00:28:29');
INSERT INTO `sys_logininfor` VALUES (286, '66666666', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-22 00:28:36');
INSERT INTO `sys_logininfor` VALUES (287, '66666666', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-22 00:32:37');
INSERT INTO `sys_logininfor` VALUES (288, '11111111', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-22 00:33:03');
INSERT INTO `sys_logininfor` VALUES (289, '11111111', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-22 00:40:33');
INSERT INTO `sys_logininfor` VALUES (290, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-22 00:40:35');
INSERT INTO `sys_logininfor` VALUES (291, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-22 00:40:40');
INSERT INTO `sys_logininfor` VALUES (292, '11111111', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-22 00:40:52');
INSERT INTO `sys_logininfor` VALUES (293, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 01:23:23');
INSERT INTO `sys_logininfor` VALUES (294, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 01:26:05');
INSERT INTO `sys_logininfor` VALUES (295, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-23 01:26:13');
INSERT INTO `sys_logininfor` VALUES (296, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-23 01:26:18');
INSERT INTO `sys_logininfor` VALUES (297, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 01:26:24');
INSERT INTO `sys_logininfor` VALUES (298, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-23 01:33:30');
INSERT INTO `sys_logininfor` VALUES (299, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 01:33:35');
INSERT INTO `sys_logininfor` VALUES (300, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 01:49:27');
INSERT INTO `sys_logininfor` VALUES (301, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 01:51:25');
INSERT INTO `sys_logininfor` VALUES (302, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 01:55:35');
INSERT INTO `sys_logininfor` VALUES (303, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 01:55:40');
INSERT INTO `sys_logininfor` VALUES (304, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 01:55:59');
INSERT INTO `sys_logininfor` VALUES (305, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 01:56:14');
INSERT INTO `sys_logininfor` VALUES (306, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 02:18:01');
INSERT INTO `sys_logininfor` VALUES (307, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-04-23 02:20:34');
INSERT INTO `sys_logininfor` VALUES (308, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 02:20:41');
INSERT INTO `sys_logininfor` VALUES (309, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 02:25:57');
INSERT INTO `sys_logininfor` VALUES (310, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-23 02:26:08');
INSERT INTO `sys_logininfor` VALUES (311, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 02:26:13');
INSERT INTO `sys_logininfor` VALUES (312, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 02:28:18');
INSERT INTO `sys_logininfor` VALUES (313, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 02:28:28');
INSERT INTO `sys_logininfor` VALUES (314, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 02:28:53');
INSERT INTO `sys_logininfor` VALUES (315, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 02:29:16');
INSERT INTO `sys_logininfor` VALUES (316, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 02:30:38');
INSERT INTO `sys_logininfor` VALUES (317, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 02:30:47');
INSERT INTO `sys_logininfor` VALUES (318, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 02:31:13');
INSERT INTO `sys_logininfor` VALUES (319, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 02:31:20');
INSERT INTO `sys_logininfor` VALUES (320, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 02:32:32');
INSERT INTO `sys_logininfor` VALUES (321, '987654321', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 02:32:46');
INSERT INTO `sys_logininfor` VALUES (322, '987654321', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 02:35:10');
INSERT INTO `sys_logininfor` VALUES (323, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 02:35:17');
INSERT INTO `sys_logininfor` VALUES (324, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 02:38:47');
INSERT INTO `sys_logininfor` VALUES (325, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 02:38:56');
INSERT INTO `sys_logininfor` VALUES (326, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 02:40:57');
INSERT INTO `sys_logininfor` VALUES (327, '987654321', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 02:41:08');
INSERT INTO `sys_logininfor` VALUES (328, '987654321', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 02:42:51');
INSERT INTO `sys_logininfor` VALUES (329, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 02:43:03');
INSERT INTO `sys_logininfor` VALUES (330, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 02:51:07');
INSERT INTO `sys_logininfor` VALUES (331, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 02:51:18');
INSERT INTO `sys_logininfor` VALUES (332, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 02:54:14');
INSERT INTO `sys_logininfor` VALUES (333, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 02:54:25');
INSERT INTO `sys_logininfor` VALUES (334, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 03:00:13');
INSERT INTO `sys_logininfor` VALUES (335, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 03:00:23');
INSERT INTO `sys_logininfor` VALUES (336, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 03:00:46');
INSERT INTO `sys_logininfor` VALUES (337, '987654321', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 03:01:01');
INSERT INTO `sys_logininfor` VALUES (338, '987654321', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 03:11:04');
INSERT INTO `sys_logininfor` VALUES (339, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 03:11:15');
INSERT INTO `sys_logininfor` VALUES (340, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 03:11:43');
INSERT INTO `sys_logininfor` VALUES (341, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-23 03:11:56');
INSERT INTO `sys_logininfor` VALUES (342, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 03:12:02');
INSERT INTO `sys_logininfor` VALUES (343, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 07:21:37');
INSERT INTO `sys_logininfor` VALUES (344, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 07:21:49');
INSERT INTO `sys_logininfor` VALUES (345, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 07:22:15');
INSERT INTO `sys_logininfor` VALUES (346, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-23 07:22:26');
INSERT INTO `sys_logininfor` VALUES (347, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 07:22:37');
INSERT INTO `sys_logininfor` VALUES (348, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 07:23:04');
INSERT INTO `sys_logininfor` VALUES (349, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 07:23:15');
INSERT INTO `sys_logininfor` VALUES (350, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 07:23:39');
INSERT INTO `sys_logininfor` VALUES (351, '987654321', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 07:23:48');
INSERT INTO `sys_logininfor` VALUES (352, '987654321', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 07:25:46');
INSERT INTO `sys_logininfor` VALUES (353, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-23 07:26:02');
INSERT INTO `sys_logininfor` VALUES (354, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 07:26:10');
INSERT INTO `sys_logininfor` VALUES (355, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 07:57:05');
INSERT INTO `sys_logininfor` VALUES (356, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 07:58:25');
INSERT INTO `sys_logininfor` VALUES (357, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:05:01');
INSERT INTO `sys_logininfor` VALUES (358, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:05:11');
INSERT INTO `sys_logininfor` VALUES (359, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:11:59');
INSERT INTO `sys_logininfor` VALUES (360, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:13:08');
INSERT INTO `sys_logininfor` VALUES (361, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:13:31');
INSERT INTO `sys_logininfor` VALUES (362, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:13:40');
INSERT INTO `sys_logininfor` VALUES (363, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:17:57');
INSERT INTO `sys_logininfor` VALUES (364, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:18:30');
INSERT INTO `sys_logininfor` VALUES (365, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:18:41');
INSERT INTO `sys_logininfor` VALUES (366, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:18:50');
INSERT INTO `sys_logininfor` VALUES (367, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:19:49');
INSERT INTO `sys_logininfor` VALUES (368, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:20:04');
INSERT INTO `sys_logininfor` VALUES (369, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:21:20');
INSERT INTO `sys_logininfor` VALUES (370, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:21:37');
INSERT INTO `sys_logininfor` VALUES (371, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:27:02');
INSERT INTO `sys_logininfor` VALUES (372, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:27:11');
INSERT INTO `sys_logininfor` VALUES (373, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:27:40');
INSERT INTO `sys_logininfor` VALUES (374, '987654321', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:27:48');
INSERT INTO `sys_logininfor` VALUES (375, '987654321', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:40:09');
INSERT INTO `sys_logininfor` VALUES (376, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:40:19');
INSERT INTO `sys_logininfor` VALUES (377, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:44:02');
INSERT INTO `sys_logininfor` VALUES (378, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:44:27');
INSERT INTO `sys_logininfor` VALUES (379, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:44:36');
INSERT INTO `sys_logininfor` VALUES (380, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:45:24');
INSERT INTO `sys_logininfor` VALUES (381, '987654321123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-04-23 08:46:59');
INSERT INTO `sys_logininfor` VALUES (382, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:47:13');
INSERT INTO `sys_logininfor` VALUES (383, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:47:57');
INSERT INTO `sys_logininfor` VALUES (384, '987654321', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:48:07');
INSERT INTO `sys_logininfor` VALUES (385, '987654321', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:48:25');
INSERT INTO `sys_logininfor` VALUES (386, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:48:33');
INSERT INTO `sys_logininfor` VALUES (387, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:48:53');
INSERT INTO `sys_logininfor` VALUES (388, '987654321', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:49:02');
INSERT INTO `sys_logininfor` VALUES (389, '987654321', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:49:41');
INSERT INTO `sys_logininfor` VALUES (390, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:49:50');
INSERT INTO `sys_logininfor` VALUES (391, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:50:06');
INSERT INTO `sys_logininfor` VALUES (392, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:50:16');
INSERT INTO `sys_logininfor` VALUES (393, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:50:37');
INSERT INTO `sys_logininfor` VALUES (394, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:50:42');
INSERT INTO `sys_logininfor` VALUES (395, '2396035961', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:52:20');
INSERT INTO `sys_logininfor` VALUES (396, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:52:28');
INSERT INTO `sys_logininfor` VALUES (397, '123456789', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-23 08:52:48');
INSERT INTO `sys_logininfor` VALUES (398, '987654321', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-23 08:52:58');
INSERT INTO `sys_logininfor` VALUES (399, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-30 06:26:16');
INSERT INTO `sys_logininfor` VALUES (400, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-30 06:56:13');
INSERT INTO `sys_logininfor` VALUES (401, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-30 06:56:19');
INSERT INTO `sys_logininfor` VALUES (402, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-30 07:04:35');
INSERT INTO `sys_logininfor` VALUES (403, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-30 07:04:41');
INSERT INTO `sys_logininfor` VALUES (404, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-30 07:05:08');
INSERT INTO `sys_logininfor` VALUES (405, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-30 07:05:12');
INSERT INTO `sys_logininfor` VALUES (406, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-30 07:05:30');
INSERT INTO `sys_logininfor` VALUES (407, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-04-30 07:05:36');
INSERT INTO `sys_logininfor` VALUES (408, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-30 07:05:39');
INSERT INTO `sys_logininfor` VALUES (409, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-30 07:08:02');
INSERT INTO `sys_logininfor` VALUES (410, '19036275', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-30 07:29:05');
INSERT INTO `sys_logininfor` VALUES (411, '19036275', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-30 08:11:10');
INSERT INTO `sys_logininfor` VALUES (412, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-30 08:11:18');
INSERT INTO `sys_logininfor` VALUES (413, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-30 08:11:28');
INSERT INTO `sys_logininfor` VALUES (414, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-30 08:11:36');
INSERT INTO `sys_logininfor` VALUES (415, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-30 08:11:50');
INSERT INTO `sys_logininfor` VALUES (416, 'bjdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-30 08:11:58');
INSERT INTO `sys_logininfor` VALUES (417, 'bjdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-30 08:20:54');
INSERT INTO `sys_logininfor` VALUES (418, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-30 08:21:01');
INSERT INTO `sys_logininfor` VALUES (419, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-30 08:27:21');
INSERT INTO `sys_logininfor` VALUES (420, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-30 08:27:27');
INSERT INTO `sys_logininfor` VALUES (421, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-30 08:27:53');
INSERT INTO `sys_logininfor` VALUES (422, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-04-30 08:28:01');
INSERT INTO `sys_logininfor` VALUES (423, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-04-30 09:23:07');
INSERT INTO `sys_logininfor` VALUES (424, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-01 00:48:39');
INSERT INTO `sys_logininfor` VALUES (425, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-01 01:31:16');
INSERT INTO `sys_logininfor` VALUES (426, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-01 01:31:36');
INSERT INTO `sys_logininfor` VALUES (427, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-01 01:41:09');
INSERT INTO `sys_logininfor` VALUES (428, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-05-01 01:43:44');
INSERT INTO `sys_logininfor` VALUES (429, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-05-01 01:43:48');
INSERT INTO `sys_logininfor` VALUES (430, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-05-01 01:43:52');
INSERT INTO `sys_logininfor` VALUES (431, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-01 01:43:55');
INSERT INTO `sys_logininfor` VALUES (432, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-01 01:50:05');
INSERT INTO `sys_logininfor` VALUES (433, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-01 01:50:19');
INSERT INTO `sys_logininfor` VALUES (434, 'bjdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-01 01:50:26');
INSERT INTO `sys_logininfor` VALUES (435, 'bjdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-01 01:52:12');
INSERT INTO `sys_logininfor` VALUES (436, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-01 01:52:23');
INSERT INTO `sys_logininfor` VALUES (437, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-01 02:05:29');
INSERT INTO `sys_logininfor` VALUES (438, 'bjdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-01 02:05:41');
INSERT INTO `sys_logininfor` VALUES (439, 'bjdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-01 02:05:49');
INSERT INTO `sys_logininfor` VALUES (440, 'jhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-05-01 02:05:57');
INSERT INTO `sys_logininfor` VALUES (441, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-01 02:06:04');
INSERT INTO `sys_logininfor` VALUES (442, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-01 02:56:17');
INSERT INTO `sys_logininfor` VALUES (443, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-01 03:46:41');
INSERT INTO `sys_logininfor` VALUES (444, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-01 08:39:18');
INSERT INTO `sys_logininfor` VALUES (445, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-02 00:38:06');
INSERT INTO `sys_logininfor` VALUES (446, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-02 00:38:54');
INSERT INTO `sys_logininfor` VALUES (447, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-02 00:54:57');
INSERT INTO `sys_logininfor` VALUES (448, 'bjdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-02 00:55:05');
INSERT INTO `sys_logininfor` VALUES (449, 'bjdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-02 00:55:16');
INSERT INTO `sys_logininfor` VALUES (450, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-02 00:55:22');
INSERT INTO `sys_logininfor` VALUES (451, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-03 00:22:53');
INSERT INTO `sys_logininfor` VALUES (452, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-05-03 00:56:15');
INSERT INTO `sys_logininfor` VALUES (453, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-03 00:56:38');
INSERT INTO `sys_logininfor` VALUES (454, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-03 01:23:45');
INSERT INTO `sys_logininfor` VALUES (455, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-03 01:23:53');
INSERT INTO `sys_logininfor` VALUES (456, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-03 03:30:05');
INSERT INTO `sys_logininfor` VALUES (457, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-03 03:35:19');
INSERT INTO `sys_logininfor` VALUES (458, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-03 03:35:25');
INSERT INTO `sys_logininfor` VALUES (459, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-03 03:35:53');
INSERT INTO `sys_logininfor` VALUES (460, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-05-03 03:37:26');
INSERT INTO `sys_logininfor` VALUES (461, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-03 03:37:29');
INSERT INTO `sys_logininfor` VALUES (462, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-03 03:38:24');
INSERT INTO `sys_logininfor` VALUES (463, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-03 03:38:29');
INSERT INTO `sys_logininfor` VALUES (464, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-03 06:13:36');
INSERT INTO `sys_logininfor` VALUES (465, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-05-03 06:16:17');
INSERT INTO `sys_logininfor` VALUES (466, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-03 06:16:25');
INSERT INTO `sys_logininfor` VALUES (467, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-03 06:46:59');
INSERT INTO `sys_logininfor` VALUES (468, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-03 06:47:00');
INSERT INTO `sys_logininfor` VALUES (469, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-03 06:47:03');
INSERT INTO `sys_logininfor` VALUES (470, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-03 07:09:54');
INSERT INTO `sys_logininfor` VALUES (471, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-03 07:25:11');
INSERT INTO `sys_logininfor` VALUES (472, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-05-03 07:25:19');
INSERT INTO `sys_logininfor` VALUES (473, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-03 07:25:25');
INSERT INTO `sys_logininfor` VALUES (474, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-03 10:32:33');
INSERT INTO `sys_logininfor` VALUES (475, '19036275', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-03 10:32:53');
INSERT INTO `sys_logininfor` VALUES (476, '19036275', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-04 09:12:23');
INSERT INTO `sys_logininfor` VALUES (477, '19036275', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-04 09:15:48');
INSERT INTO `sys_logininfor` VALUES (478, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-04 09:22:34');
INSERT INTO `sys_logininfor` VALUES (479, 't1', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-04 09:26:48');
INSERT INTO `sys_logininfor` VALUES (480, '987654321', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-04 09:27:24');
INSERT INTO `sys_logininfor` VALUES (481, '19036275', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-04 09:42:12');
INSERT INTO `sys_logininfor` VALUES (482, '19036275', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-04 09:42:21');
INSERT INTO `sys_logininfor` VALUES (483, '19036275', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-05 00:46:43');
INSERT INTO `sys_logininfor` VALUES (484, '19036275', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-05 01:33:29');
INSERT INTO `sys_logininfor` VALUES (485, '19036275', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-05 05:04:18');
INSERT INTO `sys_logininfor` VALUES (486, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-05 05:06:59');
INSERT INTO `sys_logininfor` VALUES (487, '987654321', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-05 05:07:05');
INSERT INTO `sys_logininfor` VALUES (488, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-05-05 05:07:15');
INSERT INTO `sys_logininfor` VALUES (489, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-05 05:07:24');
INSERT INTO `sys_logininfor` VALUES (490, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-05-05 05:23:20');
INSERT INTO `sys_logininfor` VALUES (491, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-05 05:23:23');
INSERT INTO `sys_logininfor` VALUES (492, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-05 05:23:23');
INSERT INTO `sys_logininfor` VALUES (493, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-05 05:29:51');
INSERT INTO `sys_logininfor` VALUES (494, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-05 05:29:58');
INSERT INTO `sys_logininfor` VALUES (495, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-05 05:36:28');
INSERT INTO `sys_logininfor` VALUES (496, 'stu01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-05-05 05:36:45');
INSERT INTO `sys_logininfor` VALUES (497, 'stu01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-05 05:36:51');
INSERT INTO `sys_logininfor` VALUES (498, 'stu01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-05 05:41:48');
INSERT INTO `sys_logininfor` VALUES (499, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-05 05:41:57');
INSERT INTO `sys_logininfor` VALUES (500, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-05 05:47:56');
INSERT INTO `sys_logininfor` VALUES (501, 'stu01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-05 05:48:06');
INSERT INTO `sys_logininfor` VALUES (502, 'root', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-05 06:16:53');
INSERT INTO `sys_logininfor` VALUES (503, 'tea01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-05 06:17:00');
INSERT INTO `sys_logininfor` VALUES (504, 'tea01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-05 06:17:27');
INSERT INTO `sys_logininfor` VALUES (505, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-05 06:17:44');
INSERT INTO `sys_logininfor` VALUES (506, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-05 06:29:15');
INSERT INTO `sys_logininfor` VALUES (507, 'tea01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-05 06:29:22');
INSERT INTO `sys_logininfor` VALUES (508, 'tea01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-05 06:29:36');
INSERT INTO `sys_logininfor` VALUES (509, 'bjdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-05 06:29:46');
INSERT INTO `sys_logininfor` VALUES (510, 'bjdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-05 06:29:53');
INSERT INTO `sys_logininfor` VALUES (511, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-05 06:29:59');
INSERT INTO `sys_logininfor` VALUES (512, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-05 06:34:10');
INSERT INTO `sys_logininfor` VALUES (513, 'p01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-05 06:34:23');
INSERT INTO `sys_logininfor` VALUES (514, 'stu01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-05 06:35:50');
INSERT INTO `sys_logininfor` VALUES (515, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-05 06:35:58');
INSERT INTO `sys_logininfor` VALUES (516, 'p01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-05 06:36:36');
INSERT INTO `sys_logininfor` VALUES (517, 'tea01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-05 06:36:41');
INSERT INTO `sys_logininfor` VALUES (518, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-05-05 06:56:46');
INSERT INTO `sys_logininfor` VALUES (519, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-05 06:56:49');
INSERT INTO `sys_logininfor` VALUES (520, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-05 07:15:46');
INSERT INTO `sys_logininfor` VALUES (521, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-10 00:17:59');
INSERT INTO `sys_logininfor` VALUES (522, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-10 00:36:12');
INSERT INTO `sys_logininfor` VALUES (523, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-10 00:36:28');
INSERT INTO `sys_logininfor` VALUES (524, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-10 00:48:37');
INSERT INTO `sys_logininfor` VALUES (525, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-10 01:50:00');
INSERT INTO `sys_logininfor` VALUES (526, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-10 01:57:00');
INSERT INTO `sys_logininfor` VALUES (527, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-10 02:13:38');
INSERT INTO `sys_logininfor` VALUES (528, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-12 12:09:12');
INSERT INTO `sys_logininfor` VALUES (529, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-12 12:09:31');
INSERT INTO `sys_logininfor` VALUES (530, 'tea01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-12 12:09:38');
INSERT INTO `sys_logininfor` VALUES (531, 'tea01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-12 12:10:43');
INSERT INTO `sys_logininfor` VALUES (532, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-12 12:10:49');
INSERT INTO `sys_logininfor` VALUES (533, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-12 12:16:39');
INSERT INTO `sys_logininfor` VALUES (534, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-12 12:16:45');
INSERT INTO `sys_logininfor` VALUES (535, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-12 12:21:32');
INSERT INTO `sys_logininfor` VALUES (536, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-21 09:22:41');
INSERT INTO `sys_logininfor` VALUES (537, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-21 09:23:49');
INSERT INTO `sys_logininfor` VALUES (538, 'tea01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-21 09:23:58');
INSERT INTO `sys_logininfor` VALUES (539, 'tea01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-22 02:28:55');
INSERT INTO `sys_logininfor` VALUES (540, 'tea01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-22 02:29:29');
INSERT INTO `sys_logininfor` VALUES (541, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-22 02:31:25');
INSERT INTO `sys_logininfor` VALUES (542, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-23 03:16:52');
INSERT INTO `sys_logininfor` VALUES (543, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-05-23 03:16:59');
INSERT INTO `sys_logininfor` VALUES (544, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-23 03:17:05');
INSERT INTO `sys_logininfor` VALUES (545, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-24 00:38:27');
INSERT INTO `sys_logininfor` VALUES (546, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-24 01:13:25');
INSERT INTO `sys_logininfor` VALUES (547, 'tea01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-24 01:13:37');
INSERT INTO `sys_logininfor` VALUES (548, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-24 01:34:33');
INSERT INTO `sys_logininfor` VALUES (549, 'qhdx', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-24 02:00:26');
INSERT INTO `sys_logininfor` VALUES (550, 'tea02', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-24 02:00:33');
INSERT INTO `sys_logininfor` VALUES (551, 'tea02', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-24 02:00:43');
INSERT INTO `sys_logininfor` VALUES (552, 'stu02', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-24 02:00:54');
INSERT INTO `sys_logininfor` VALUES (553, 'stu02', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-05-24 02:01:56');
INSERT INTO `sys_logininfor` VALUES (554, 'pro01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-05-24 02:02:05');
INSERT INTO `sys_logininfor` VALUES (555, 'p01', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-05-24 02:02:22');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int(1) NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int(1) NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2008 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2025-04-12 10:31:26', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2025-04-12 10:31:26', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2025-04-12 10:31:26', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 0, 0, 'M', '0', '0', '', 'guide', 'admin', '2025-04-12 10:31:26', '', NULL, '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2025-04-12 10:31:26', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2025-04-12 10:31:26', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2025-04-12 10:31:26', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2025-04-12 10:31:26', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2025-04-12 10:31:26', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2025-04-12 10:31:26', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2025-04-12 10:31:26', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2025-04-12 10:31:26', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2025-04-12 10:31:26', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2025-04-12 10:31:26', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2025-04-12 10:31:26', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2025-04-12 10:31:26', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2025-04-12 10:31:26', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2025-04-12 10:31:26', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2025-04-12 10:31:26', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2025-04-12 10:31:26', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2025-04-12 10:31:26', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2025-04-12 10:31:26', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2025-04-12 10:31:26', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2025-04-12 10:31:27', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2025-04-12 10:31:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2025-04-12 10:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '信息管理', 0, 0, 'person', NULL, NULL, '', 1, 0, 'M', '0', '0', '', '#', 'admin', '2025-04-17 08:19:31', 'admin', '2025-05-22 02:31:57', '');
INSERT INTO `sys_menu` VALUES (2001, '学生信息管理', 2000, 0, 'student', 'person/student/index', NULL, '', 1, 1, 'C', '0', '0', '', '#', 'admin', '2025-04-17 08:24:34', 'admin', '2025-05-22 02:34:00', '');
INSERT INTO `sys_menu` VALUES (2002, '教师信息管理', 2000, 1, 'teacher', 'person/teacher/index', NULL, '', 1, 1, 'C', '0', '0', '', '#', 'admin', '2025-04-19 08:56:44', 'admin', '2025-05-22 02:34:07', '');
INSERT INTO `sys_menu` VALUES (2003, '大创项目', 0, 1, 'project', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, '#', 'admin', '2025-04-19 09:52:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2004, '项目管理', 2003, 0, 'list', 'innoProject/index', NULL, '', 1, 1, 'C', '0', '0', '', '#', 'admin', '2025-04-19 09:53:26', 'admin', '2025-05-05 05:29:20', '');
INSERT INTO `sys_menu` VALUES (2005, '专家信息管理', 2000, 2, 'profession', 'person/professional/index', NULL, '', 1, 1, 'C', '0', '0', '', '#', 'admin', '2025-04-20 01:33:01', 'admin', '2025-05-22 02:34:14', '');
INSERT INTO `sys_menu` VALUES (2006, '学校信息管理', 2000, 3, 'school', 'person/school/index', NULL, '', 1, 1, 'C', '0', '0', '', '#', 'admin', '2025-04-30 06:59:24', 'admin', '2025-05-22 02:34:21', '');
INSERT INTO `sys_menu` VALUES (2007, '项目经费', 2003, 1, 'fee', 'innoProject/fundManage', NULL, '', 1, 1, 'C', '0', '0', '', '#', 'admin', '2025-04-30 09:29:26', 'admin', '2025-05-05 05:29:25', '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int(4) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2025-04-12 10:31:40', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2025-04-12 10:31:40', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int(2) NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int(1) NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int(1) NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint(20) NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type`) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status`) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 266 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '代码生成', 6, 'com.xinghe.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"student\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 08:06:48', 603);
INSERT INTO `sys_oper_log` VALUES (101, '代码生成', 2, 'com.xinghe.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/student', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 08:06:52', 543);
INSERT INTO `sys_oper_log` VALUES (102, '代码生成', 2, 'com.xinghe.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/student', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 08:08:03', 570);
INSERT INTO `sys_oper_log` VALUES (103, '代码生成', 2, 'com.xinghe.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"student\",\"className\":\"Student\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":1,\"columnName\":\"id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-17 08:06:48\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2025-04-17 08:08:02\",\"usableColumn\":false},{\"capJavaField\":\"StuNo\",\"columnComment\":\"学号\",\"columnId\":2,\"columnName\":\"stu_no\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-17 08:06:48\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"stuNo\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2025-04-17 08:08:02\",\"usableColumn\":false},{\"capJavaField\":\"StuName\",\"columnComment\":\"学生姓名\",\"columnId\":3,\"columnName\":\"stu_name\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-17 08:06:48\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"stuName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2025-04-17 08:08:02\",\"usableColumn\":false},{\"capJavaField\":\"Speciality\",\"columnComment\":\"专业\",\"columnId\":4,\"columnName\":\"speciality\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-17 08:06:48\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isI', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 08:08:56', 535);
INSERT INTO `sys_oper_log` VALUES (104, '代码生成', 2, 'com.xinghe.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"student\",\"className\":\"Student\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":1,\"columnName\":\"id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-17 08:06:48\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2025-04-17 08:08:56\",\"usableColumn\":false},{\"capJavaField\":\"StuNo\",\"columnComment\":\"学号\",\"columnId\":2,\"columnName\":\"stu_no\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-17 08:06:48\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"stuNo\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2025-04-17 08:08:56\",\"usableColumn\":false},{\"capJavaField\":\"StuName\",\"columnComment\":\"学生姓名\",\"columnId\":3,\"columnName\":\"stu_name\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-17 08:06:48\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"stuName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2025-04-17 08:08:56\",\"usableColumn\":false},{\"capJavaField\":\"Speciality\",\"columnComment\":\"专业\",\"columnId\":4,\"columnName\":\"speciality\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-17 08:06:48\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isInc', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 08:11:03', 513);
INSERT INTO `sys_oper_log` VALUES (105, '代码生成', 8, 'com.xinghe.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"student\"}', NULL, 0, NULL, '2025-04-17 08:11:06', 73);
INSERT INTO `sys_oper_log` VALUES (106, '代码生成', 8, 'com.xinghe.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"student\"}', NULL, 0, NULL, '2025-04-17 08:11:28', 62);
INSERT INTO `sys_oper_log` VALUES (107, '菜单管理', 1, 'com.xinghe.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"学生管理\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"student\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 08:19:31', 111);
INSERT INTO `sys_oper_log` VALUES (108, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-04-17 08:19:31\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"人员管理\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"person\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 08:21:42', 85);
INSERT INTO `sys_oper_log` VALUES (109, '菜单管理', 1, 'com.xinghe.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"person/student/indedx\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"学生信息维护\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2000,\"path\":\"student\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 08:24:34', 69);
INSERT INTO `sys_oper_log` VALUES (110, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"person/student/indedx\",\"createTime\":\"2025-04-17 08:24:34\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"学生信息维护\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2000,\"path\":\"student\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 08:25:14', 151);
INSERT INTO `sys_oper_log` VALUES (111, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-04-17 08:19:31\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"人员管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"person\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 08:26:27', 69);
INSERT INTO `sys_oper_log` VALUES (112, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"person/student/index\",\"createTime\":\"2025-04-17 08:24:34\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"学生信息维护\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2000,\"path\":\"student\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 08:27:38', 78);
INSERT INTO `sys_oper_log` VALUES (113, '学生', 1, 'com.xinghe.web.controller.StudentController.add()', 'POST', 1, 'admin', '研发部门', '/student/student', '127.0.0.1', '内网IP', '{\"email\":\"赛f\",\"id\":1,\"inTime\":\"2025-04-07\",\"phoneNum\":\"塞法\",\"speciality\":\"塞法\",\"stuName\":\"张明\",\"stuNo\":\"19036275\",\"userId\":\"sdff dfs\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 08:28:31', 61);
INSERT INTO `sys_oper_log` VALUES (114, '学生', 3, 'com.xinghe.web.controller.StudentController.remove()', 'DELETE', 1, 'admin', '研发部门', '/student/student/1', '127.0.0.1', '内网IP', '[1]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 08:28:41', 166);
INSERT INTO `sys_oper_log` VALUES (115, '学生', 1, 'com.xinghe.web.controller.StudentController.add()', 'POST', 1, 'admin', '研发部门', '/student/student', '127.0.0.1', '内网IP', '{\"email\":\"3er2r2r2r@qq.com\",\"id\":2,\"inTime\":\"2025-04-29\",\"phoneNum\":\"13333333333\",\"speciality\":\"金融学\",\"stuName\":\"wef\",\"stuNo\":\"12312313112\",\"userId\":\"345555555555555555\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 08:57:58', 119);
INSERT INTO `sys_oper_log` VALUES (116, '学生', 5, 'com.xinghe.web.controller.StudentController.export()', 'POST', 1, 'admin', '研发部门', '/student/student/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2025-04-17 09:00:06', 804);
INSERT INTO `sys_oper_log` VALUES (117, '用户管理', 1, 'com.xinghe.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"张三\",\"params\":{},\"postIds\":[],\"roleIds\":[],\"status\":\"0\",\"userId\":100,\"userName\":\"aphler\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 09:05:36', 226);
INSERT INTO `sys_oper_log` VALUES (118, '角色管理', 1, 'com.xinghe.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"roleId\":100,\"roleKey\":\"stu\",\"roleName\":\"学生\",\"roleSort\":0,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 09:08:17', 160);
INSERT INTO `sys_oper_log` VALUES (119, '用户管理', 1, 'com.xinghe.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"appp\",\"params\":{},\"postIds\":[],\"roleIds\":[100],\"status\":\"0\",\"userId\":101,\"userName\":\"a1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 09:08:40', 250);
INSERT INTO `sys_oper_log` VALUES (120, '学生', 1, 'com.xinghe.web.controller.StudentController.add()', 'POST', 1, 'admin', '研发部门', '/student/student', '127.0.0.1', '内网IP', '{\"email\":\"edwe@qq.conm\",\"id\":3,\"inTime\":\"2025-04-28\",\"phoneNum\":\"13333333333\",\"speciality\":\"计算机科学与技术\",\"stuName\":\"翁灵魂\",\"stuNo\":\"190337772\",\"userId\":\"344444444444444444\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 09:14:54', 108);
INSERT INTO `sys_oper_log` VALUES (121, '学生', 1, 'com.xinghe.web.controller.StudentController.add()', 'POST', 1, 'admin', '研发部门', '/student/student', '127.0.0.1', '内网IP', '{\"email\":\"13231@qqq.cc\",\"id\":4,\"inTime\":\"2025-04-29\",\"phoneNum\":\"13333333333\",\"speciality\":\"计算机科学与技术\",\"stuName\":\"1321\",\"stuNo\":\"123123123\",\"userId\":\"355555555555555555\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-17 09:16:45', 267);
INSERT INTO `sys_oper_log` VALUES (122, '代码生成', 6, 'com.xinghe.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"teacher\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 08:45:06', 523);
INSERT INTO `sys_oper_log` VALUES (123, '代码生成', 2, 'com.xinghe.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/teacher', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 08:46:21', 471);
INSERT INTO `sys_oper_log` VALUES (124, '代码生成', 2, 'com.xinghe.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"teacher\",\"className\":\"Teacher\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":10,\"columnName\":\"id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-19 08:45:06\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-04-19 08:46:21\",\"usableColumn\":false},{\"capJavaField\":\"Account\",\"columnComment\":\"账号\",\"columnId\":11,\"columnName\":\"account\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-19 08:45:06\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"account\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-04-19 08:46:21\",\"usableColumn\":false},{\"capJavaField\":\"TeacherName\",\"columnComment\":\"老师姓名\",\"columnId\":12,\"columnName\":\"teacher_name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-19 08:45:06\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"teacherName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-04-19 08:46:21\",\"usableColumn\":false},{\"capJavaField\":\"Gender\",\"columnComment\":\"性别\",\"columnId\":13,\"columnName\":\"gender\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-19 08:45:06\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"i', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 08:47:08', 569);
INSERT INTO `sys_oper_log` VALUES (125, '代码生成', 6, 'com.xinghe.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"professional\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 08:47:26', 780);
INSERT INTO `sys_oper_log` VALUES (126, '代码生成', 2, 'com.xinghe.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"professional\",\"className\":\"Professional\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":17,\"columnName\":\"id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-19 08:47:25\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Account\",\"columnComment\":\"账号\",\"columnId\":18,\"columnName\":\"account\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-19 08:47:25\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"account\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"专家姓名\",\"columnId\":19,\"columnName\":\"name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-19 08:47:25\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Area\",\"columnComment\":\"领域\",\"columnId\":20,\"columnName\":\"area\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-19 08:47:26\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"area\",\"ja', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 08:48:04', 712);
INSERT INTO `sys_oper_log` VALUES (127, '代码生成', 8, 'com.xinghe.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"teacher\"}', NULL, 0, NULL, '2025-04-19 08:48:09', 110);
INSERT INTO `sys_oper_log` VALUES (128, '代码生成', 2, 'com.xinghe.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"teacher\",\"className\":\"Teacher\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":10,\"columnName\":\"id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-19 08:45:06\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-04-19 08:47:08\",\"usableColumn\":false},{\"capJavaField\":\"Account\",\"columnComment\":\"账号\",\"columnId\":11,\"columnName\":\"account\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-19 08:45:06\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"account\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-04-19 08:47:08\",\"usableColumn\":false},{\"capJavaField\":\"TeacherName\",\"columnComment\":\"老师姓名\",\"columnId\":12,\"columnName\":\"teacher_name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-19 08:45:06\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"teacherName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-04-19 08:47:08\",\"usableColumn\":false},{\"capJavaField\":\"Gender\",\"columnComment\":\"性别\",\"columnId\":13,\"columnName\":\"gender\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-04-19 08:45:06\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"i', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 08:50:27', 600);
INSERT INTO `sys_oper_log` VALUES (129, '代码生成', 8, 'com.xinghe.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"teacher\"}', NULL, 0, NULL, '2025-04-19 08:50:30', 50);
INSERT INTO `sys_oper_log` VALUES (130, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"person/student/index\",\"createTime\":\"2025-04-17 08:24:34\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"学生信息录入\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2000,\"path\":\"student\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 08:56:15', 86);
INSERT INTO `sys_oper_log` VALUES (131, '菜单管理', 1, 'com.xinghe.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"person/teacher/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"教师录入\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"teacher\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 08:56:44', 85);
INSERT INTO `sys_oper_log` VALUES (132, '角色管理', 1, 'com.xinghe.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"roleId\":101,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":0,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 09:03:45', 191);
INSERT INTO `sys_oper_log` VALUES (133, '老师', 1, 'com.xinghe.web.controller.TeacherController.add()', 'POST', 1, 'admin', '研发部门', '/person/teacher', '127.0.0.1', '内网IP', '{\"account\":\"teacher1\",\"degree\":\"专科\",\"gender\":\"男\",\"id\":1,\"level\":\"中级\",\"teacherName\":\"王五\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 09:04:40', 74);
INSERT INTO `sys_oper_log` VALUES (134, '老师', 1, 'com.xinghe.web.controller.TeacherController.add()', 'POST', 1, 'admin', '研发部门', '/person/teacher', '127.0.0.1', '内网IP', '{\"account\":\"teacher2\",\"degree\":\"wqe\",\"gender\":\"qwe\",\"id\":2,\"level\":\"qewq\",\"teacherName\":\"qw\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 09:06:08', 62);
INSERT INTO `sys_oper_log` VALUES (135, '老师', 1, 'com.xinghe.web.controller.TeacherController.add()', 'POST', 1, 'admin', '研发部门', '/person/teacher', '127.0.0.1', '内网IP', '{\"account\":\"teacher1\",\"degree\":\"123\",\"gender\":\"123\",\"id\":3,\"level\":\"1231\",\"teacherName\":\"123\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 09:07:34', 342);
INSERT INTO `sys_oper_log` VALUES (136, '代码生成', 6, 'com.xinghe.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"inno_project\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 09:12:09', 5341);
INSERT INTO `sys_oper_log` VALUES (137, '代码生成', 2, 'com.xinghe.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/inno_project', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 09:20:15', 1124);
INSERT INTO `sys_oper_log` VALUES (138, '代码生成', 2, 'com.xinghe.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/inno_project', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 09:20:33', 1091);
INSERT INTO `sys_oper_log` VALUES (139, '代码生成', 2, 'com.xinghe.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/inno_project', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 09:21:11', 1096);
INSERT INTO `sys_oper_log` VALUES (140, '代码生成', 2, 'com.xinghe.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/inno_project', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 09:21:14', 1051);
INSERT INTO `sys_oper_log` VALUES (141, '菜单管理', 1, 'com.xinghe.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"大创项目\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"project\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 09:52:58', 84);
INSERT INTO `sys_oper_log` VALUES (142, '菜单管理', 1, 'com.xinghe.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"项目管理\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2003,\"path\":\"list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 09:53:26', 78);
INSERT INTO `sys_oper_log` VALUES (143, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"innoProject/index\",\"createTime\":\"2025-04-19 09:53:26\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2004,\"menuName\":\"项目管理\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2003,\"path\":\"list\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-19 09:54:05', 80);
INSERT INTO `sys_oper_log` VALUES (144, '角色管理', 1, 'com.xinghe.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"roleId\":102,\"roleKey\":\"profession\",\"roleName\":\"专家\",\"roleSort\":0,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-20 01:31:29', 180);
INSERT INTO `sys_oper_log` VALUES (145, '菜单管理', 1, 'com.xinghe.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"person/profession/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"专家录入\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"profession\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-20 01:33:01', 90);
INSERT INTO `sys_oper_log` VALUES (146, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"person/professional/index\",\"createTime\":\"2025-04-20 01:33:01\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2005,\"menuName\":\"专家录入\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"profession\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-20 01:33:44', 90);
INSERT INTO `sys_oper_log` VALUES (147, '角色管理', 2, 'com.xinghe.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-04-17 09:08:17\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2003,2004],\"params\":{},\"roleId\":100,\"roleKey\":\"stu\",\"roleName\":\"学生\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-20 12:23:13', 309);
INSERT INTO `sys_oper_log` VALUES (148, '角色管理', 2, 'com.xinghe.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-04-19 09:03:45\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2003,2004],\"params\":{},\"roleId\":101,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-20 12:23:19', 266);
INSERT INTO `sys_oper_log` VALUES (149, '角色管理', 2, 'com.xinghe.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-04-20 01:31:29\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2003,2004],\"params\":{},\"roleId\":102,\"roleKey\":\"profession\",\"roleName\":\"专家\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-20 12:23:26', 251);
INSERT INTO `sys_oper_log` VALUES (150, '学生', 1, 'com.xinghe.web.controller.StudentController.add()', 'POST', 1, 'admin', '研发部门', '/student/student', '127.0.0.1', '内网IP', '{\"email\":\"123123@c.com\",\"id\":5,\"inTime\":\"2025-04-22\",\"phoneNum\":\"13333333333\",\"speciality\":\"计算机科学与技术\",\"stuName\":\"王广康\",\"stuNo\":\"19036275\",\"userId\":\"344444444444444444\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-21 09:38:45', 359);
INSERT INTO `sys_oper_log` VALUES (151, '学生', 1, 'com.xinghe.web.controller.StudentController.add()', 'POST', 1, 'admin', '研发部门', '/student/student', '192.168.0.24', '内网IP', '{\"email\":\"2383998024@qq.com\",\"id\":6,\"inTime\":\"2025-04-02\",\"phoneNum\":\"19999999999\",\"speciality\":\"金融学\",\"stuName\":\"孙月\",\"stuNo\":\"11111111\",\"userId\":\"370202000000000000\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-21 11:23:18', 348);
INSERT INTO `sys_oper_log` VALUES (152, '学生', 1, 'com.xinghe.web.controller.StudentController.add()', 'POST', 1, 'admin', '研发部门', '/student/student', '192.168.0.24', '内网IP', '{\"email\":\"2383998024@qq.com\",\"id\":7,\"inTime\":\"2025-04-01\",\"phoneNum\":\"19999999999\",\"speciality\":\"计算机科学与技术\",\"stuName\":\"ij\",\"stuNo\":\"22222222\",\"userId\":\"370202000000000000\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-21 11:25:24', 340);
INSERT INTO `sys_oper_log` VALUES (153, '学生', 1, 'com.xinghe.web.controller.StudentController.add()', 'POST', 1, 'admin', '研发部门', '/student/student', '192.168.0.24', '内网IP', '{\"email\":\"2383998024@qq.com\",\"id\":8,\"inTime\":\"2025-04-19\",\"phoneNum\":\"19999999999\",\"speciality\":\"临床医学\",\"stuName\":\"hhg\",\"stuNo\":\"33333333\",\"userId\":\"370202111111111111\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-21 11:26:04', 308);
INSERT INTO `sys_oper_log` VALUES (154, '角色管理', 1, 'com.xinghe.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2001,2002,2005,2003,2004],\"params\":{},\"roleId\":103,\"roleKey\":\"ad\",\"roleName\":\"ad\",\"roleSort\":0,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-23 01:24:47', 708);
INSERT INTO `sys_oper_log` VALUES (155, '角色管理', 3, 'com.xinghe.web.controller.system.SysRoleController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/role/103', '127.0.0.1', '内网IP', '[103]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-23 01:25:16', 917);
INSERT INTO `sys_oper_log` VALUES (156, '角色管理', 1, 'com.xinghe.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2001,2002,2005,2003,2004],\"params\":{},\"roleId\":104,\"roleKey\":\"ad\",\"roleName\":\"管理员\",\"roleSort\":0,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-23 01:25:38', 721);
INSERT INTO `sys_oper_log` VALUES (157, '用户管理', 1, 'com.xinghe.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"root\",\"params\":{},\"postIds\":[],\"roleIds\":[104],\"status\":\"0\",\"userId\":114,\"userName\":\"root\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-23 01:26:01', 473);
INSERT INTO `sys_oper_log` VALUES (158, '学生', 1, 'com.xinghe.web.controller.StudentController.add()', 'POST', 1, 'root', NULL, '/student/student', '127.0.0.1', '内网IP', '{\"email\":\"2396035961@qq.com\",\"id\":9,\"inTime\":\"2021-09-01\",\"phoneNum\":\"13830763604\",\"speciality\":\"计算机科学与技术\",\"stuName\":\"姜珊\",\"stuNo\":\"2396035961\",\"userId\":\"62212320020307002X\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-23 01:53:51', 1004);
INSERT INTO `sys_oper_log` VALUES (159, '学生', 5, 'com.xinghe.web.controller.StudentController.export()', 'POST', 1, 'root', NULL, '/student/student/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2025-04-23 01:56:34', 602);
INSERT INTO `sys_oper_log` VALUES (160, '学生', 5, 'com.xinghe.web.controller.StudentController.export()', 'POST', 1, 'root', NULL, '/student/student/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2025-04-23 02:16:01', 964);
INSERT INTO `sys_oper_log` VALUES (161, '菜单管理', 1, 'com.xinghe.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"person/school/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"学校录入\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2000,\"path\":\"school\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-30 06:59:24', 90);
INSERT INTO `sys_oper_log` VALUES (162, '角色管理', 1, 'com.xinghe.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2001,2002,2003,2004],\"params\":{},\"roleId\":105,\"roleKey\":\"school\",\"roleName\":\"学校\",\"roleSort\":0,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-30 07:04:28', 263);
INSERT INTO `sys_oper_log` VALUES (163, '角色管理', 2, 'com.xinghe.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-04-23 01:25:38\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2001,2002,2005,2006,2003,2004],\"params\":{},\"roleId\":104,\"roleKey\":\"ad\",\"roleName\":\"管理员\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-30 07:05:27', 258);
INSERT INTO `sys_oper_log` VALUES (164, '学生', 1, 'com.xinghe.web.controller.StudentController.add()', 'POST', 1, 'root', NULL, '/student/student', '127.0.0.1', '内网IP', '{\"email\":\"123123@qqwd.com\",\"id\":10,\"inTime\":\"2025-04-02\",\"phoneNum\":\"13333333333\",\"schoolId\":2,\"schoolName\":\"清华大学\",\"speciality\":\"计算机科学与技术\",\"stuName\":\"张三\",\"stuNo\":\"19036275\",\"userId\":\"345555555555555555\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-30 07:15:14', 408);
INSERT INTO `sys_oper_log` VALUES (165, '菜单管理', 1, 'com.xinghe.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"innoProject/fundManage\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"项目经费\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2003,\"path\":\"fee\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-30 09:29:26', 92);
INSERT INTO `sys_oper_log` VALUES (166, '经费预算管理', 1, 'com.xinghe.web.controller.InnoProjectFundBudgetController.add()', 'POST', 1, 'admin', '研发部门', '/web/fundBudget', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-04-30 09:54:07', 95);
INSERT INTO `sys_oper_log` VALUES (167, '角色管理', 2, 'com.xinghe.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-04-30 07:04:28\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2001,2002,2003,2004,2007],\"params\":{},\"roleId\":105,\"roleKey\":\"school\",\"roleName\":\"学校\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-01 01:30:58', 298);
INSERT INTO `sys_oper_log` VALUES (168, '角色管理', 2, 'com.xinghe.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-04-19 09:03:45\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2003,2004,2007],\"params\":{},\"roleId\":101,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-01 01:31:12', 299);
INSERT INTO `sys_oper_log` VALUES (169, '经费预算管理', 3, 'com.xinghe.web.controller.InnoProjectFundBudgetController.remove()', 'DELETE', 1, 't1', NULL, '/web/fundBudget/1', '127.0.0.1', '内网IP', '[1]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-01 01:47:52', 155);
INSERT INTO `sys_oper_log` VALUES (170, '经费预算管理', 1, 'com.xinghe.web.controller.InnoProjectFundBudgetController.add()', 'POST', 1, 't1', NULL, '/web/fundBudget', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-01 01:48:00', 70);
INSERT INTO `sys_oper_log` VALUES (171, '经费预算管理', 2, 'com.xinghe.web.controller.InnoProjectFundBudgetController.edit()', 'PUT', 1, 't1', NULL, '/web/fundBudget', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-01 02:04:48', 115);
INSERT INTO `sys_oper_log` VALUES (172, '经费预算管理', 2, 'com.xinghe.web.controller.InnoProjectFundBudgetController.submit()', 'PUT', 1, 't1', NULL, '/web/fundBudget/submit/2', '127.0.0.1', '内网IP', '2', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-01 02:09:02', 100);
INSERT INTO `sys_oper_log` VALUES (173, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 't1', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-01 03:07:08', 102);
INSERT INTO `sys_oper_log` VALUES (174, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 't1', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-01 03:20:39', 67);
INSERT INTO `sys_oper_log` VALUES (175, '经费支出管理', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.submit()', 'PUT', 1, 't1', NULL, '/web/fundExpense/submit/2', '127.0.0.1', '内网IP', '2', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-02 00:55:34', 93);
INSERT INTO `sys_oper_log` VALUES (176, '经费支出管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundExpense/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":2,\"schoolApproveDesc\":\"tsy\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-02 00:56:05', 144);
INSERT INTO `sys_oper_log` VALUES (177, '经费预算管理', 1, 'com.xinghe.web.controller.InnoProjectFundBudgetController.add()', 'POST', 1, 'qhdx', NULL, '/web/fundBudget', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 00:49:42', 112);
INSERT INTO `sys_oper_log` VALUES (178, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 'qhdx', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"只能关联已批准的预算\",\"code\":500}', 0, NULL, '2025-05-03 00:55:54', 56);
INSERT INTO `sys_oper_log` VALUES (179, '经费预算管理', 2, 'com.xinghe.web.controller.InnoProjectFundBudgetController.submit()', 'PUT', 1, 'qhdx', NULL, '/web/fundBudget/submit/3', '127.0.0.1', '内网IP', '3', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 00:58:26', 82);
INSERT INTO `sys_oper_log` VALUES (180, '经费预算管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundBudgetController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundBudget/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":3,\"schoolApproveDesc\":\"统一航航后\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 01:05:23', 19390);
INSERT INTO `sys_oper_log` VALUES (181, '经费预算管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundBudgetController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundBudget/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":3,\"schoolApproveDesc\":\"统一航航后\"}', NULL, 1, '只有已提交的经费预算才能审批', '2025-05-03 01:05:31', 38487);
INSERT INTO `sys_oper_log` VALUES (182, '经费预算管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundBudgetController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundBudget/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":3,\"schoolApproveDesc\":\"统一航航后\"}', NULL, 1, '只有已提交的经费预算才能审批', '2025-05-03 01:05:34', 103);
INSERT INTO `sys_oper_log` VALUES (183, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 'qhdx', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"预算剩余金额不足，剩余123.00元，支出123123元\",\"code\":500}', 0, NULL, '2025-05-03 01:06:18', 240);
INSERT INTO `sys_oper_log` VALUES (184, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 'qhdx', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"预算剩余金额不足，剩余123.00元，支出123123元\",\"code\":500}', 0, NULL, '2025-05-03 01:17:29', 47);
INSERT INTO `sys_oper_log` VALUES (185, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 'qhdx', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 01:17:34', 128);
INSERT INTO `sys_oper_log` VALUES (186, '经费支出管理', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.submit()', 'PUT', 1, 'qhdx', NULL, '/web/fundExpense/submit/3', '127.0.0.1', '内网IP', '3', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 01:19:05', 96);
INSERT INTO `sys_oper_log` VALUES (187, '经费支出管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundExpense/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":3,\"schoolApproveDesc\":\"\"}', '{\"msg\":\"审批说明不能为空\",\"code\":500}', 0, NULL, '2025-05-03 01:19:07', 2);
INSERT INTO `sys_oper_log` VALUES (188, '经费支出管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundExpense/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":3,\"schoolApproveDesc\":\"纷纷\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 01:19:11', 325);
INSERT INTO `sys_oper_log` VALUES (189, '经费预算管理', 1, 'com.xinghe.web.controller.InnoProjectFundBudgetController.add()', 'POST', 1, 't1', NULL, '/web/fundBudget', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 01:27:59', 78);
INSERT INTO `sys_oper_log` VALUES (190, '经费预算管理', 2, 'com.xinghe.web.controller.InnoProjectFundBudgetController.submit()', 'PUT', 1, 't1', NULL, '/web/fundBudget/submit/4', '127.0.0.1', '内网IP', '4', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 01:30:39', 87);
INSERT INTO `sys_oper_log` VALUES (191, '经费预算管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundBudgetController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundBudget/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":4,\"schoolApproveDesc\":\"\"}', '{\"msg\":\"审批说明不能为空\",\"code\":500}', 0, NULL, '2025-05-03 01:30:52', 0);
INSERT INTO `sys_oper_log` VALUES (192, '经费预算管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundBudgetController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundBudget/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":4,\"schoolApproveDesc\":\"啊啊啊啊爱\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 01:30:56', 144);
INSERT INTO `sys_oper_log` VALUES (193, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 't1', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 01:32:47', 110);
INSERT INTO `sys_oper_log` VALUES (194, '经费支出管理', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.submit()', 'PUT', 1, 't1', NULL, '/web/fundExpense/submit/4', '127.0.0.1', '内网IP', '4', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 01:41:42', 100);
INSERT INTO `sys_oper_log` VALUES (195, '经费支出管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundExpense/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":4,\"schoolApproveDesc\":\"\"}', '{\"msg\":\"审批说明不能为空\",\"code\":500}', 0, NULL, '2025-05-03 01:41:56', 7);
INSERT INTO `sys_oper_log` VALUES (196, '经费支出管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundExpense/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":4,\"schoolApproveDesc\":\"东方\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 01:41:59', 328);
INSERT INTO `sys_oper_log` VALUES (197, '经费支付记录管理', 1, 'com.xinghe.web.controller.InnoProjectFundPaymentController.add()', 'POST', 1, 'qhdx', NULL, '/web/fundPayment', '127.0.0.1', '内网IP', '{\"createBy\":\"qhdx\",\"createByName\":\"清华大学\",\"createTime\":\"2025-05-03 09:42:33.798\",\"expenseId\":4,\"id\":1,\"paymentAmount\":200,\"paymentDate\":\"2025-05-19 00:00:00\",\"paymentDesc\":\"玩儿费\",\"paymentMethod\":\"BANK\",\"projectId\":17}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 01:42:37', 260);
INSERT INTO `sys_oper_log` VALUES (198, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 't1', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"预算剩余金额不足，剩余300.00元，支出12313元\",\"code\":500}', 0, NULL, '2025-05-03 01:43:15', 23);
INSERT INTO `sys_oper_log` VALUES (199, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 't1', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 01:43:32', 516);
INSERT INTO `sys_oper_log` VALUES (200, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 't1', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 01:48:46', 113);
INSERT INTO `sys_oper_log` VALUES (201, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 't1', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 01:51:48', 430);
INSERT INTO `sys_oper_log` VALUES (202, '经费支出管理', 3, 'com.xinghe.web.controller.InnoProjectFundExpenseController.remove()', 'DELETE', 1, 't1', NULL, '/web/fundExpense/7', '127.0.0.1', '内网IP', '[7]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 02:01:14', 153);
INSERT INTO `sys_oper_log` VALUES (203, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 't1', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 02:01:40', 87);
INSERT INTO `sys_oper_log` VALUES (204, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 't1', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 02:04:48', 274);
INSERT INTO `sys_oper_log` VALUES (205, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 't1', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 02:07:00', 270);
INSERT INTO `sys_oper_log` VALUES (206, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 't1', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 02:10:19', 260);
INSERT INTO `sys_oper_log` VALUES (207, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 't1', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 02:12:56', 82);
INSERT INTO `sys_oper_log` VALUES (208, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 't1', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 02:15:12', 267);
INSERT INTO `sys_oper_log` VALUES (209, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 't1', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 02:46:35', 106);
INSERT INTO `sys_oper_log` VALUES (210, '经费支出管理', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.submit()', 'PUT', 1, 't1', NULL, '/web/fundExpense/submit/14', '127.0.0.1', '内网IP', '14', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 02:49:08', 95);
INSERT INTO `sys_oper_log` VALUES (211, '经费支出管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundExpense/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":14,\"schoolApproveDesc\":\"\"}', '{\"msg\":\"审批说明不能为空\",\"code\":500}', 0, NULL, '2025-05-03 02:49:20', 0);
INSERT INTO `sys_oper_log` VALUES (212, '经费支出管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundExpense/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":14,\"schoolApproveDesc\":\"放大\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 02:49:23', 346);
INSERT INTO `sys_oper_log` VALUES (213, '经费支出管理', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.submit()', 'PUT', 1, 't1', NULL, '/web/fundExpense/submit/11', '127.0.0.1', '内网IP', '11', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 02:49:40', 78);
INSERT INTO `sys_oper_log` VALUES (214, '经费支出管理', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.submit()', 'PUT', 1, 't1', NULL, '/web/fundExpense/submit/10', '127.0.0.1', '内网IP', '10', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 02:49:42', 75);
INSERT INTO `sys_oper_log` VALUES (215, '经费支出管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundExpense/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":11,\"schoolApproveDesc\":\"\"}', '{\"msg\":\"审批说明不能为空\",\"code\":500}', 0, NULL, '2025-05-03 02:49:52', 0);
INSERT INTO `sys_oper_log` VALUES (216, '经费支出管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundExpense/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":11,\"schoolApproveDesc\":\"放大\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-03 02:49:55', 281);
INSERT INTO `sys_oper_log` VALUES (217, '经费支出管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundExpense/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":10,\"schoolApproveDesc\":\"阿萨德发\"}', NULL, 1, '预算剩余金额不足，无法批准支出', '2025-05-03 02:49:58', 175);
INSERT INTO `sys_oper_log` VALUES (218, '经费支出管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundExpense/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":10,\"schoolApproveDesc\":\"阿萨德发\"}', NULL, 1, '预算剩余金额不足，无法批准支出', '2025-05-03 02:50:01', 197);
INSERT INTO `sys_oper_log` VALUES (219, '学生', 5, 'com.xinghe.web.controller.StudentController.export()', 'POST', 1, 'qhdx', NULL, '/student/student/export', '127.0.0.1', '内网IP', '{\"inTime\":\"\",\"speciality\":\"\",\"pageSize\":\"10\",\"phoneNum\":\"\",\"stuName\":\"\",\"pageNum\":\"1\",\"userId\":\"\",\"stuNo\":\"\",\"email\":\"\"}', NULL, 0, NULL, '2025-05-03 07:06:30', 354);
INSERT INTO `sys_oper_log` VALUES (220, '学生', 5, 'com.xinghe.web.controller.StudentController.export()', 'POST', 1, 'qhdx', NULL, '/student/student/export', '127.0.0.1', '内网IP', '{\"inTime\":\"\",\"speciality\":\"\",\"pageSize\":\"10\",\"phoneNum\":\"\",\"stuName\":\"\",\"pageNum\":\"1\",\"userId\":\"\",\"stuNo\":\"\",\"email\":\"\"}', NULL, 0, NULL, '2025-05-03 07:18:21', 55);
INSERT INTO `sys_oper_log` VALUES (221, '学生', 6, 'com.xinghe.web.controller.StudentController.importData()', 'POST', 1, 'root', NULL, '/student/student/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 1 条，数据如下：<br/>第 1 条数据导入成功\",\"code\":200}', 0, NULL, '2025-05-03 07:32:25', 1388);
INSERT INTO `sys_oper_log` VALUES (222, '学生', 6, 'com.xinghe.web.controller.StudentController.importData()', 'POST', 1, 'root', NULL, '/student/student/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 1 条，数据如下：（注意：学校名称\\\"清华大学\\\"已匹配为\\\"清华大学\\\"）<br/>第 1 条数据导入成功\",\"code\":200}', 0, NULL, '2025-05-03 07:41:41', 2543);
INSERT INTO `sys_oper_log` VALUES (223, '学生', 6, 'com.xinghe.web.controller.StudentController.importData()', 'POST', 1, 'root', NULL, '/student/student/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 1 条，数据如下：（注意：学校名称\\\"清华大学\\\"已匹配为\\\"清华大学\\\"）<br/>第 1 条数据导入成功\",\"code\":200}', 0, NULL, '2025-05-03 07:42:22', 473);
INSERT INTO `sys_oper_log` VALUES (224, '学生', 6, 'com.xinghe.web.controller.StudentController.importData()', 'POST', 1, 'root', NULL, '/student/student/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', NULL, 1, '很抱歉，导入失败！共 1 条数据格式不正确，错误如下：<br/>第 1 条数据导入失败：未找到完全匹配的学校 [大学]', '2025-05-03 07:46:16', 3118);
INSERT INTO `sys_oper_log` VALUES (225, '学生', 6, 'com.xinghe.web.controller.StudentController.importData()', 'POST', 1, 'root', NULL, '/student/student/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', NULL, 1, '很抱歉，导入失败！共 1 条数据格式不正确，错误如下：<br/>第 1 条数据导入失败：未找到完全匹配的学校 [大学]', '2025-05-03 07:49:02', 386);
INSERT INTO `sys_oper_log` VALUES (226, '学生', 6, 'com.xinghe.web.controller.StudentController.importData()', 'POST', 1, 'root', NULL, '/student/student/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 1 条，数据如下：<br/>第 1 条数据导入成功\",\"code\":200}', 0, NULL, '2025-05-03 07:50:22', 62232);
INSERT INTO `sys_oper_log` VALUES (227, '学生', 6, 'com.xinghe.web.controller.StudentController.importData()', 'POST', 1, 'root', NULL, '/student/student/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', NULL, 1, '很抱歉，导入失败！共 1 条数据格式不正确，错误如下：<br/>第 1 条数据导入失败：nested exception is org.apache.ibatis.binding.BindingException: Parameter \'userName\' not found. Available parameters are [userCode, param1]', '2025-05-03 07:57:28', 362);
INSERT INTO `sys_oper_log` VALUES (228, '学生', 6, 'com.xinghe.web.controller.StudentController.importData()', 'POST', 1, 'root', NULL, '/student/student/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', NULL, 1, '很抱歉，导入失败！共 1 条数据格式不正确，错误如下：<br/>第 1 条数据导入失败：nested exception is org.apache.ibatis.binding.BindingException: Parameter \'userName\' not found. Available parameters are [userCode, param1]', '2025-05-03 07:59:07', 508);
INSERT INTO `sys_oper_log` VALUES (229, '学生', 6, 'com.xinghe.web.controller.StudentController.importData()', 'POST', 1, 'root', NULL, '/student/student/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', NULL, 1, '很抱歉，导入失败！共 1 条数据格式不正确，错误如下：<br/>第 1 条数据导入失败：该学号已有学生', '2025-05-03 08:00:03', 606);
INSERT INTO `sys_oper_log` VALUES (230, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"person/student/index\",\"createTime\":\"2025-04-17 08:24:34\",\"icon\":\"#\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"学生信息录入\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2000,\"path\":\"student\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-05 05:28:51', 91);
INSERT INTO `sys_oper_log` VALUES (231, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"person/student/index\",\"createTime\":\"2025-04-17 08:24:34\",\"icon\":\"#\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"学生信息录入\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2000,\"path\":\"student\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-05 05:28:55', 81);
INSERT INTO `sys_oper_log` VALUES (232, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"person/teacher/index\",\"createTime\":\"2025-04-19 08:56:44\",\"icon\":\"#\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"教师录入\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"teacher\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-05 05:28:59', 83);
INSERT INTO `sys_oper_log` VALUES (233, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"person/professional/index\",\"createTime\":\"2025-04-20 01:33:01\",\"icon\":\"#\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2005,\"menuName\":\"专家录入\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"profession\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-05 05:29:04', 100);
INSERT INTO `sys_oper_log` VALUES (234, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"person/school/index\",\"createTime\":\"2025-04-30 06:59:24\",\"icon\":\"#\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2006,\"menuName\":\"学校录入\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2000,\"path\":\"school\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-05 05:29:08', 100);
INSERT INTO `sys_oper_log` VALUES (235, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"innoProject/index\",\"createTime\":\"2025-04-19 09:53:26\",\"icon\":\"#\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2004,\"menuName\":\"项目管理\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2003,\"path\":\"list\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-05 05:29:20', 85);
INSERT INTO `sys_oper_log` VALUES (236, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"innoProject/fundManage\",\"createTime\":\"2025-04-30 09:29:26\",\"icon\":\"#\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2007,\"menuName\":\"项目经费\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2003,\"path\":\"fee\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-05 05:29:25', 68);
INSERT INTO `sys_oper_log` VALUES (237, '学生', 1, 'com.xinghe.web.controller.StudentController.add()', 'POST', 1, 'qhdx', NULL, '/student/student', '127.0.0.1', '内网IP', '{\"email\":\"1231\",\"id\":17,\"inTime\":\"2025-05-06\",\"phoneNum\":\"1231\",\"schoolId\":4,\"schoolName\":\"清华大学\",\"speciality\":\"计算机科学与技术\",\"stuName\":\"学生01\",\"stuNo\":\"stu01\",\"userId\":\"123\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-05 05:31:13', 354);
INSERT INTO `sys_oper_log` VALUES (238, '学生', 6, 'com.xinghe.web.controller.StudentController.importData()', 'POST', 1, 'admin', '研发部门', '/student/student/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 1 条，数据如下：<br/>第 1 条数据导入成功\",\"code\":200}', 0, NULL, '2025-05-05 05:33:51', 1498);
INSERT INTO `sys_oper_log` VALUES (239, '老师', 6, 'com.xinghe.web.controller.TeacherController.importData()', 'POST', 1, 'root', NULL, '/person/teacher/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 1 条，数据如下：<br/>第 1 条数据导入成功\",\"code\":200}', 0, NULL, '2025-05-05 05:45:53', 464);
INSERT INTO `sys_oper_log` VALUES (240, '大创项目', 6, 'com.xinghe.web.controller.InnoProjectController.importData()', 'POST', 1, 'stu01', NULL, '/web/innoProject/importData', '127.0.0.1', '内网IP', '', '{\"msg\":\"请上传Excel文件\",\"code\":500}', 0, NULL, '2025-05-05 06:05:16', 6);
INSERT INTO `sys_oper_log` VALUES (241, '大创项目', 6, 'com.xinghe.web.controller.InnoProjectController.importData()', 'POST', 1, 'stu01', NULL, '/web/innoProject/importData', '127.0.0.1', '内网IP', '', '{\"msg\":\"请上传Excel文件\",\"code\":500}', 0, NULL, '2025-05-05 06:05:20', 0);
INSERT INTO `sys_oper_log` VALUES (242, '大创项目', 6, 'com.xinghe.web.controller.InnoProjectController.importData()', 'POST', 1, 'stu01', NULL, '/web/innoProject/importData', '127.0.0.1', '内网IP', '', '{\"msg\":\"恭喜您，数据已导入成功！共 0 条很抱歉，导入失败！共 1 条数据导入失败，错误如下：<br/>第 1 行数据导入失败: 项目类型无效: 创新创业项目\",\"code\":200}', 0, NULL, '2025-05-05 06:11:04', 295);
INSERT INTO `sys_oper_log` VALUES (243, '大创项目', 6, 'com.xinghe.web.controller.InnoProjectController.importData()', 'POST', 1, 'stu01', NULL, '/web/innoProject/importData', '127.0.0.1', '内网IP', '', '{\"msg\":\"恭喜您，数据已导入成功！共 0 条很抱歉，导入失败！共 1 条数据导入失败，错误如下：<br/>第 1 行数据导入失败: 项目类型无效: 创新创业项目\",\"code\":200}', 0, NULL, '2025-05-05 06:11:19', 62);
INSERT INTO `sys_oper_log` VALUES (244, '大创项目', 6, 'com.xinghe.web.controller.InnoProjectController.importData()', 'POST', 1, 'stu01', NULL, '/web/innoProject/importData', '127.0.0.1', '内网IP', '', '{\"msg\":\"恭喜您，数据已导入成功！共 0 条很抱歉，导入失败！共 1 条数据导入失败，错误如下：<br/>第 1 行数据导入失败: 项目类型无效: 创建训练项目\",\"code\":200}', 0, NULL, '2025-05-05 06:12:09', 299);
INSERT INTO `sys_oper_log` VALUES (245, '大创项目', 6, 'com.xinghe.web.controller.InnoProjectController.importData()', 'POST', 1, 'stu01', NULL, '/web/innoProject/importData', '127.0.0.1', '内网IP', '', '{\"msg\":\"恭喜您，数据已导入成功！共 1 条<br/>第 1 行数据导入成功: pro02\",\"code\":200}', 0, NULL, '2025-05-05 06:13:54', 900);
INSERT INTO `sys_oper_log` VALUES (246, '经费预算管理', 1, 'com.xinghe.web.controller.InnoProjectFundBudgetController.add()', 'POST', 1, 'tea01', NULL, '/web/fundBudget', '127.0.0.1', '内网IP', '{\"submit\":\"true\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-05 06:37:04', 65);
INSERT INTO `sys_oper_log` VALUES (247, '经费预算管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundBudgetController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundBudget/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":5,\"schoolApproveDesc\":\"\"}', '{\"msg\":\"审批说明不能为空\",\"code\":500}', 0, NULL, '2025-05-05 06:37:11', 4);
INSERT INTO `sys_oper_log` VALUES (248, '经费预算管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundBudgetController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundBudget/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":5,\"schoolApproveDesc\":\"123\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-05 06:37:13', 164);
INSERT INTO `sys_oper_log` VALUES (249, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 'tea01', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"true\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-05 06:38:07', 288);
INSERT INTO `sys_oper_log` VALUES (250, '经费支出管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundExpense/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":15,\"schoolApproveDesc\":\"qw\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-05 06:39:33', 306);
INSERT INTO `sys_oper_log` VALUES (251, '经费支付记录管理', 1, 'com.xinghe.web.controller.InnoProjectFundPaymentController.add()', 'POST', 1, 'qhdx', NULL, '/web/fundPayment', '127.0.0.1', '内网IP', '{\"createBy\":\"qhdx\",\"createByName\":\"清华大学\",\"createTime\":\"2025-05-05 14:39:46.065\",\"expenseId\":15,\"id\":2,\"paymentAmount\":123,\"paymentDate\":\"2025-05-06 00:00:00\",\"paymentDesc\":\"qwe\",\"paymentMethod\":\"OTHER\",\"projectId\":19}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-05 06:39:46', 264);
INSERT INTO `sys_oper_log` VALUES (252, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-04-17 08:19:31\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"信息管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"person\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-22 02:31:57', 123);
INSERT INTO `sys_oper_log` VALUES (253, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"person/student/index\",\"createTime\":\"2025-04-17 08:24:34\",\"icon\":\"#\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"学生信息管理\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2000,\"path\":\"student\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-22 02:34:00', 88);
INSERT INTO `sys_oper_log` VALUES (254, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"person/teacher/index\",\"createTime\":\"2025-04-19 08:56:44\",\"icon\":\"#\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"教师信息管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"teacher\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-22 02:34:07', 94);
INSERT INTO `sys_oper_log` VALUES (255, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"person/professional/index\",\"createTime\":\"2025-04-20 01:33:01\",\"icon\":\"#\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2005,\"menuName\":\"专家信息管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"profession\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-22 02:34:14', 83);
INSERT INTO `sys_oper_log` VALUES (256, '菜单管理', 2, 'com.xinghe.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"person/school/index\",\"createTime\":\"2025-04-30 06:59:24\",\"icon\":\"#\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2006,\"menuName\":\"学校信息管理\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2000,\"path\":\"school\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-22 02:34:21', 85);
INSERT INTO `sys_oper_log` VALUES (257, '经费预算管理', 1, 'com.xinghe.web.controller.InnoProjectFundBudgetController.add()', 'POST', 1, 'tea01', NULL, '/web/fundBudget', '127.0.0.1', '内网IP', '{\"submit\":\"true\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'budget_type\' doesn\'t have a default value\r\n### The error may exist in com/xinghe/web/mapper/InnoProjectFundBudgetMapper.java (best guess)\r\n### The error may involve com.xinghe.web.mapper.InnoProjectFundBudgetMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO inno_project_fund_budget  ( project_id, budget_name,  budget_amount, remaining_amount, material_amount, travel_amount, meeting_amount, print_amount, other_amount, budget_desc, status,         create_by, create_by_name, create_time )  VALUES (  ?, ?,  ?, ?, ?, ?, ?, ?, ?, ?, ?,         ?, ?, ?  )\r\n### Cause: java.sql.SQLException: Field \'budget_type\' doesn\'t have a default value\n; Field \'budget_type\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'budget_type\' doesn\'t have a default value', '2025-05-24 01:33:07', 233);
INSERT INTO `sys_oper_log` VALUES (258, '经费预算管理', 1, 'com.xinghe.web.controller.InnoProjectFundBudgetController.add()', 'POST', 1, 'tea01', NULL, '/web/fundBudget', '127.0.0.1', '内网IP', '{\"submit\":\"true\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'budget_type\' doesn\'t have a default value\r\n### The error may exist in com/xinghe/web/mapper/InnoProjectFundBudgetMapper.java (best guess)\r\n### The error may involve com.xinghe.web.mapper.InnoProjectFundBudgetMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO inno_project_fund_budget  ( project_id, budget_name,  budget_amount, remaining_amount, material_amount, travel_amount, meeting_amount, print_amount, other_amount, budget_desc, status,         create_by, create_by_name, create_time )  VALUES (  ?, ?,  ?, ?, ?, ?, ?, ?, ?, ?, ?,         ?, ?, ?  )\r\n### Cause: java.sql.SQLException: Field \'budget_type\' doesn\'t have a default value\n; Field \'budget_type\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'budget_type\' doesn\'t have a default value', '2025-05-24 01:33:12', 116);
INSERT INTO `sys_oper_log` VALUES (259, '经费预算管理', 1, 'com.xinghe.web.controller.InnoProjectFundBudgetController.add()', 'POST', 1, 'tea01', NULL, '/web/fundBudget', '127.0.0.1', '内网IP', '{\"submit\":\"true\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'budget_type\' doesn\'t have a default value\r\n### The error may exist in com/xinghe/web/mapper/InnoProjectFundBudgetMapper.java (best guess)\r\n### The error may involve com.xinghe.web.mapper.InnoProjectFundBudgetMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO inno_project_fund_budget  ( project_id, budget_name,  budget_amount, remaining_amount, material_amount, travel_amount, meeting_amount, print_amount, other_amount, budget_desc, status,         create_by, create_by_name, create_time )  VALUES (  ?, ?,  ?, ?, ?, ?, ?, ?, ?, ?, ?,         ?, ?, ?  )\r\n### Cause: java.sql.SQLException: Field \'budget_type\' doesn\'t have a default value\n; Field \'budget_type\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'budget_type\' doesn\'t have a default value', '2025-05-24 01:33:17', 144);
INSERT INTO `sys_oper_log` VALUES (260, '经费预算管理', 1, 'com.xinghe.web.controller.InnoProjectFundBudgetController.add()', 'POST', 1, 'tea01', NULL, '/web/fundBudget', '127.0.0.1', '内网IP', '{\"submit\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-24 01:34:06', 147);
INSERT INTO `sys_oper_log` VALUES (261, '经费预算管理', 2, 'com.xinghe.web.controller.InnoProjectFundBudgetController.submit()', 'PUT', 1, 'tea01', NULL, '/web/fundBudget/submit/6', '127.0.0.1', '内网IP', '6', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-24 01:34:58', 212);
INSERT INTO `sys_oper_log` VALUES (262, '经费预算管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundBudgetController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundBudget/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":6,\"schoolApproveDesc\":\"GGGGKJJK\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-24 01:35:59', 425);
INSERT INTO `sys_oper_log` VALUES (263, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 'tea01', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"true\"}', NULL, 1, '材料费超出预算金额', '2025-05-24 01:36:36', 144);
INSERT INTO `sys_oper_log` VALUES (264, '经费支出管理', 1, 'com.xinghe.web.controller.InnoProjectFundExpenseController.add()', 'POST', 1, 'tea01', NULL, '/web/fundExpense', '127.0.0.1', '内网IP', '{\"submit\":\"true\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-24 01:36:47', 265);
INSERT INTO `sys_oper_log` VALUES (265, '经费支出管理-学校审批', 2, 'com.xinghe.web.controller.InnoProjectFundExpenseController.schoolApprove()', 'POST', 1, 'qhdx', NULL, '/web/fundExpense/school-approve/true', '127.0.0.1', '内网IP', 'true {\"id\":16,\"schoolApproveDesc\":\"efws\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-05-24 01:37:02', 717);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int(4) NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '岗位信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2025-04-12 10:31:24', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2025-04-12 10:31:24', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2025-04-12 10:31:24', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2025-04-12 10:31:24', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(4) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 106 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2025-04-12 10:31:25', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2025-04-12 10:31:25', '', NULL, '普通角色');
INSERT INTO `sys_role` VALUES (100, '学生', 'stu', 0, '1', 1, 1, '0', '0', 'admin', '2025-04-17 09:08:17', 'admin', '2025-04-20 12:23:13', NULL);
INSERT INTO `sys_role` VALUES (101, '教师', 'teacher', 0, '1', 1, 1, '0', '0', 'admin', '2025-04-19 09:03:45', 'admin', '2025-05-01 01:31:12', NULL);
INSERT INTO `sys_role` VALUES (102, '专家', 'profession', 0, '1', 1, 1, '0', '0', 'admin', '2025-04-20 01:31:29', 'admin', '2025-04-20 12:23:26', NULL);
INSERT INTO `sys_role` VALUES (103, 'ad', 'ad', 0, '1', 1, 1, '0', '2', 'admin', '2025-04-23 01:24:47', '', NULL, NULL);
INSERT INTO `sys_role` VALUES (104, '管理员', 'ad', 0, '1', 1, 1, '0', '0', 'admin', '2025-04-23 01:25:38', 'admin', '2025-04-30 07:05:27', NULL);
INSERT INTO `sys_role` VALUES (105, '学校', 'school', 0, '1', 1, 1, '0', '0', 'admin', '2025-04-30 07:04:28', 'admin', '2025-05-01 01:30:58', NULL);

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(20) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色和部门关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);
INSERT INTO `sys_role_menu` VALUES (100, 2003);
INSERT INTO `sys_role_menu` VALUES (100, 2004);
INSERT INTO `sys_role_menu` VALUES (101, 2003);
INSERT INTO `sys_role_menu` VALUES (101, 2004);
INSERT INTO `sys_role_menu` VALUES (101, 2007);
INSERT INTO `sys_role_menu` VALUES (102, 2003);
INSERT INTO `sys_role_menu` VALUES (102, 2004);
INSERT INTO `sys_role_menu` VALUES (104, 2000);
INSERT INTO `sys_role_menu` VALUES (104, 2001);
INSERT INTO `sys_role_menu` VALUES (104, 2002);
INSERT INTO `sys_role_menu` VALUES (104, 2003);
INSERT INTO `sys_role_menu` VALUES (104, 2004);
INSERT INTO `sys_role_menu` VALUES (104, 2005);
INSERT INTO `sys_role_menu` VALUES (104, 2006);
INSERT INTO `sys_role_menu` VALUES (105, 2000);
INSERT INTO `sys_role_menu` VALUES (105, 2001);
INSERT INTO `sys_role_menu` VALUES (105, 2002);
INSERT INTO `sys_role_menu` VALUES (105, 2003);
INSERT INTO `sys_role_menu` VALUES (105, 2004);
INSERT INTO `sys_role_menu` VALUES (105, 2007);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint(20) NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 134 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-05-22 10:31:26', 'admin', '2025-04-12 10:31:24', '', '2025-05-22 02:31:25', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-04-12 10:31:24', 'admin', '2025-04-12 10:31:24', '', NULL, '测试员');
INSERT INTO `sys_user` VALUES (114, NULL, 'root', 'root', '00', '', '', '0', '', '$2a$10$txE/OD6/NPkCPBd.VMRAX.7l89fDqnaQqhdAdeXBaDGWndw./HUwq', '0', '0', '127.0.0.1', '2025-05-05 13:41:58', 'admin', '2025-04-23 01:26:01', '', '2025-05-05 05:41:57', NULL);
INSERT INTO `sys_user` VALUES (127, NULL, 'qhdx', '清华大学', '00', '', '', '0', '', '$2a$10$nx3Q9MLqY8haZPaYexgb1OPry3VhHxCyLwPFfHXK8X0uwoxsWN2MO', '0', '0', '127.0.0.1', '2025-05-24 09:34:33', '', '2025-05-05 05:23:56', '', '2025-05-24 01:34:33', NULL);
INSERT INTO `sys_user` VALUES (128, NULL, 'bjdx', '北京大学', '00', '', '', '0', '', '$2a$10$TsV8PrwIl.bBv4gHs46zwu2qsDZgJ2CRMO7xd.GHpfNwfHJeuwbYi', '0', '0', '127.0.0.1', '2025-05-05 14:29:46', '', '2025-05-05 05:24:28', '', '2025-05-05 06:29:46', NULL);
INSERT INTO `sys_user` VALUES (129, NULL, 'stu01', '学生01', '00', '', '', '0', '', '$2a$10$xY9FD16tURPExRRQyTAUqOWMSmBZqOVvcZTLbY.ufGuJ6AbVWi.sq', '0', '0', '127.0.0.1', '2025-05-05 13:48:06', '', '2025-05-05 05:31:13', '', '2025-05-05 05:48:06', NULL);
INSERT INTO `sys_user` VALUES (130, NULL, 'stu02', '学生02', '00', '', '', '0', '', '$2a$10$WDPnzpzpb9HFn24cKAXQhuFB42IqA6d2.T.tok.pTMjKpZMb5OWCS', '0', '0', '127.0.0.1', '2025-05-24 10:00:54', '', '2025-05-05 05:33:51', '', '2025-05-24 02:00:54', NULL);
INSERT INTO `sys_user` VALUES (131, NULL, 'tea01', '教师01', '00', '', '', '0', '', '$2a$10$gBvGvELkksENRVwH/O4JmOgU1LGkW0lDqHdwIis6PA2oken1y0PPu', '0', '0', '127.0.0.1', '2025-05-24 09:13:37', '', '2025-05-05 05:35:18', '', '2025-05-24 01:13:37', NULL);
INSERT INTO `sys_user` VALUES (132, NULL, 'p01', '专家01', '00', '', '', '0', '', '$2a$10$aDa7s5LvFlS7I/DiQWXGb.UJNr7OwECxdSefoBBeklQS0YLw9ns3i', '0', '0', '127.0.0.1', '2025-05-24 10:02:22', '', '2025-05-05 05:36:17', '', '2025-05-24 02:02:22', NULL);
INSERT INTO `sys_user` VALUES (133, NULL, 'tea02', '教师02', '00', '', '', '0', '', '$2a$10$wzq4fqa7rMBEqF1zO0agauxa0uxyHyX6J2ytOFoIp9uG6ARDzc3hC', '0', '0', '127.0.0.1', '2025-05-24 10:00:34', '', '2025-05-05 05:45:52', '', '2025-05-24 02:00:33', NULL);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `post_id` bigint(20) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);
INSERT INTO `sys_user_role` VALUES (101, 100);
INSERT INTO `sys_user_role` VALUES (102, 100);
INSERT INTO `sys_user_role` VALUES (103, 101);
INSERT INTO `sys_user_role` VALUES (104, 102);
INSERT INTO `sys_user_role` VALUES (105, 102);
INSERT INTO `sys_user_role` VALUES (106, 100);
INSERT INTO `sys_user_role` VALUES (107, 100);
INSERT INTO `sys_user_role` VALUES (108, 100);
INSERT INTO `sys_user_role` VALUES (109, 100);
INSERT INTO `sys_user_role` VALUES (110, 101);
INSERT INTO `sys_user_role` VALUES (111, 101);
INSERT INTO `sys_user_role` VALUES (112, 102);
INSERT INTO `sys_user_role` VALUES (113, 102);
INSERT INTO `sys_user_role` VALUES (114, 104);
INSERT INTO `sys_user_role` VALUES (115, 100);
INSERT INTO `sys_user_role` VALUES (116, 101);
INSERT INTO `sys_user_role` VALUES (117, 102);
INSERT INTO `sys_user_role` VALUES (118, 105);
INSERT INTO `sys_user_role` VALUES (119, 105);
INSERT INTO `sys_user_role` VALUES (120, 100);
INSERT INTO `sys_user_role` VALUES (121, 101);
INSERT INTO `sys_user_role` VALUES (122, 105);
INSERT INTO `sys_user_role` VALUES (123, 100);
INSERT INTO `sys_user_role` VALUES (124, 100);
INSERT INTO `sys_user_role` VALUES (125, 100);
INSERT INTO `sys_user_role` VALUES (126, 100);
INSERT INTO `sys_user_role` VALUES (127, 105);
INSERT INTO `sys_user_role` VALUES (128, 105);
INSERT INTO `sys_user_role` VALUES (129, 100);
INSERT INTO `sys_user_role` VALUES (130, 100);
INSERT INTO `sys_user_role` VALUES (131, 101);
INSERT INTO `sys_user_role` VALUES (132, 102);
INSERT INTO `sys_user_role` VALUES (133, 101);

-- ----------------------------
-- Table structure for teacher
-- ----------------------------
DROP TABLE IF EXISTS `teacher`;
CREATE TABLE `teacher`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `account` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '账号',
  `teacher_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '老师姓名',
  `gender` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '性别',
  `level` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '级别',
  `degree` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学历',
  `school_id` bigint(20) NULL DEFAULT NULL COMMENT '学校ID',
  `school_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学校',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '老师' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of teacher
-- ----------------------------
INSERT INTO `teacher` VALUES (8, 'tea01', '教师01', '男', '助教', '硕士', 4, '清华大学', '2025-05-05 05:35:18');
INSERT INTO `teacher` VALUES (9, 'tea02', '教师02', '女', '讲师', '本科', 5, '北京大学', '2025-05-05 05:45:52');

SET FOREIGN_KEY_CHECKS = 1;
