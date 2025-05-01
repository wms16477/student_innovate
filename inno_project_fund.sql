-- 创建经费预算表
CREATE TABLE `inno_project_fund_budget` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `project_id` bigint NOT NULL COMMENT '项目ID',
  `budget_type` varchar(50) NOT NULL COMMENT '预算类型(MATERIAL:材料费,TRAVEL:差旅费,MEETING:会议费,PRINT:印刷费,OTHER:其他费用)',
  `budget_amount` decimal(10,2) NOT NULL COMMENT '预算金额',
  `budget_desc` varchar(500) DEFAULT NULL COMMENT '预算说明',
  `status` varchar(20) NOT NULL COMMENT '状态(DRAFT:草稿,SUBMITTED:已提交,APPROVED:已批准,REJECTED:已拒绝)',
  `approve_by` varchar(30) DEFAULT NULL COMMENT '审批人',
  `approve_by_name` varchar(30) DEFAULT NULL COMMENT '审批人姓名',
  `approve_time` datetime DEFAULT NULL COMMENT '审批时间',
  `approve_desc` varchar(500) DEFAULT NULL COMMENT '审批说明',
  `create_by` varchar(30) NOT NULL COMMENT '创建人',
  `create_by_name` varchar(30) NOT NULL COMMENT '创建人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `school_approve_by` varchar(30) DEFAULT NULL COMMENT '学校审批人',
  `school_approve_by_name` varchar(30) DEFAULT NULL COMMENT '学校审批人姓名',
  `school_approve_time` datetime DEFAULT NULL COMMENT '学校审批时间',
  `school_approve_desc` varchar(500) DEFAULT NULL COMMENT '学校审批说明',
  PRIMARY KEY (`id`),
  KEY `idx_project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目经费预算表';

-- 创建经费支出申请表
CREATE TABLE `inno_project_fund_expense` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `project_id` bigint NOT NULL COMMENT '项目ID',
  `budget_id` bigint DEFAULT NULL COMMENT '预算ID',
  `expense_type` varchar(50) NOT NULL COMMENT '支出类型(MATERIAL:材料费,TRAVEL:差旅费,MEETING:会议费,PRINT:印刷费,OTHER:其他费用)',
  `expense_amount` decimal(10,2) NOT NULL COMMENT '支出金额',
  `expense_desc` varchar(500) DEFAULT NULL COMMENT '支出说明',
  `expense_date` date DEFAULT NULL COMMENT '支出日期',
  `file_url` varchar(255) DEFAULT NULL COMMENT '票据附件',
  `status` varchar(20) NOT NULL COMMENT '状态(DRAFT:草稿,SUBMITTED:已提交,APPROVED:已批准,REJECTED:已拒绝,PAID:已支付)',
  `approve_by` varchar(30) DEFAULT NULL COMMENT '审批人',
  `approve_by_name` varchar(30) DEFAULT NULL COMMENT '审批人姓名',
  `approve_time` datetime DEFAULT NULL COMMENT '审批时间',
  `approve_desc` varchar(500) DEFAULT NULL COMMENT '审批说明',
  `create_by` varchar(30) NOT NULL COMMENT '创建人',
  `create_by_name` varchar(30) NOT NULL COMMENT '创建人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `school_approve_by` varchar(30) DEFAULT NULL COMMENT '学校审批人',
  `school_approve_by_name` varchar(30) DEFAULT NULL COMMENT '学校审批人姓名',
  `school_approve_time` datetime DEFAULT NULL COMMENT '学校审批时间',
  `school_approve_desc` varchar(500) DEFAULT NULL COMMENT '学校审批说明',
  PRIMARY KEY (`id`),
  KEY `idx_project_id` (`project_id`),
  KEY `idx_budget_id` (`budget_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目经费支出表';

-- 创建经费支付记录表
CREATE TABLE `inno_project_fund_payment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `expense_id` bigint NOT NULL COMMENT '支出申请ID',
  `project_id` bigint NOT NULL COMMENT '项目ID',
  `payment_amount` decimal(10,2) NOT NULL COMMENT '支付金额',
  `payment_date` datetime NOT NULL COMMENT '支付日期',
  `payment_method` varchar(50) DEFAULT NULL COMMENT '支付方式(CASH:现金,BANK:银行转账,OTHER:其他)',
  `payment_desc` varchar(500) DEFAULT NULL COMMENT '支付说明',
  `create_by` varchar(30) NOT NULL COMMENT '创建人',
  `create_by_name` varchar(30) NOT NULL COMMENT '创建人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_expense_id` (`expense_id`),
  KEY `idx_project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目经费支付记录表'; 