-- 1. 修改经费预算表，添加各类型金额字段
ALTER TABLE `inno_project_fund_budget` 
ADD COLUMN `material_amount` decimal(10,2) DEFAULT 0 COMMENT '材料费金额',
ADD COLUMN `travel_amount` decimal(10,2) DEFAULT 0 COMMENT '差旅费金额',
ADD COLUMN `meeting_amount` decimal(10,2) DEFAULT 0 COMMENT '会议费金额',
ADD COLUMN `print_amount` decimal(10,2) DEFAULT 0 COMMENT '印刷费金额',
ADD COLUMN `other_amount` decimal(10,2) DEFAULT 0 COMMENT '其他费用金额';

-- 2. 修改经费支出表，添加各类型金额字段
ALTER TABLE `inno_project_fund_expense` 
ADD COLUMN `material_amount` decimal(10,2) DEFAULT 0 COMMENT '材料费金额',
ADD COLUMN `travel_amount` decimal(10,2) DEFAULT 0 COMMENT '差旅费金额',
ADD COLUMN `meeting_amount` decimal(10,2) DEFAULT 0 COMMENT '会议费金额',
ADD COLUMN `print_amount` decimal(10,2) DEFAULT 0 COMMENT '印刷费金额',
ADD COLUMN `other_amount` decimal(10,2) DEFAULT 0 COMMENT '其他费用金额';

-- 3. 从已有数据中更新新增字段的值（基于原有的类型字段）
UPDATE `inno_project_fund_budget` 
SET `material_amount` = CASE WHEN `budget_type` = 'MATERIAL' THEN `budget_amount` ELSE 0 END,
    `travel_amount` = CASE WHEN `budget_type` = 'TRAVEL' THEN `budget_amount` ELSE 0 END,
    `meeting_amount` = CASE WHEN `budget_type` = 'MEETING' THEN `budget_amount` ELSE 0 END,
    `print_amount` = CASE WHEN `budget_type` = 'PRINT' THEN `budget_amount` ELSE 0 END,
    `other_amount` = CASE WHEN `budget_type` = 'OTHER' THEN `budget_amount` ELSE 0 END;
    
UPDATE `inno_project_fund_expense` 
SET `material_amount` = CASE WHEN `expense_type` = 'MATERIAL' THEN `expense_amount` ELSE 0 END,
    `travel_amount` = CASE WHEN `expense_type` = 'TRAVEL' THEN `expense_amount` ELSE 0 END,
    `meeting_amount` = CASE WHEN `expense_type` = 'MEETING' THEN `expense_amount` ELSE 0 END,
    `print_amount` = CASE WHEN `expense_type` = 'PRINT' THEN `expense_amount` ELSE 0 END,
    `other_amount` = CASE WHEN `expense_type` = 'OTHER' THEN `expense_amount` ELSE 0 END;

-- 4. 更新经费支出表的状态，将已支付状态改为已批准
UPDATE `inno_project_fund_expense` SET `status` = 'APPROVED' WHERE `status` = 'PAID';

-- 5. 删除支付记录表（如果有需要的话）
DROP TABLE IF EXISTS `inno_project_fund_payment`;

-- 6. 更新FundStatusEnum中的相关状态（这个需要在Java代码中处理） 