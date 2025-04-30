-- 创建学校表
CREATE TABLE `school` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `school_code` varchar(30) NOT NULL COMMENT '学校编码',
  `school_name` varchar(100) NOT NULL COMMENT '学校名称',
  `address` varchar(255) DEFAULT NULL COMMENT '学校地址',
  `contact_phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `create_by` varchar(30) DEFAULT NULL COMMENT '创建人',
  `create_by_name` varchar(30) DEFAULT NULL COMMENT '创建人姓名',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `del_flag` tinyint NOT NULL DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='学校表';

-- 修改学生表，添加学校ID字段
ALTER TABLE `student` 
ADD COLUMN `school_id` bigint DEFAULT NULL COMMENT '学校ID' AFTER `user_id`;

-- 修改老师表，添加学校ID字段
ALTER TABLE `teacher` 
ADD COLUMN `school_id` bigint DEFAULT NULL COMMENT '学校ID' AFTER `degree`;

-- 修改项目表，添加学校审批相关字段
ALTER TABLE `inno_project` 
ADD COLUMN `school_approve_status` varchar(20) DEFAULT NULL COMMENT '学校审批状态',
ADD COLUMN `school_approve_desc` varchar(255) DEFAULT NULL COMMENT '学校审批意见'; 