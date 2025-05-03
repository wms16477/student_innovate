package com.xinghe.web.service;

import java.util.Map;

/**
 * 项目经费分析统计 服务层
 * 
 * @author xinghe
 */
public interface InnoProjectFundAnalysisService {
    
    /**
     * 获取项目经费总体概况
     * 
     * @param projectId 项目ID
     * @return 经费总体概况数据
     */
    Map<String, Object> getProjectFundOverview(Long projectId);
    
    /**
     * 获取预算使用情况统计
     * 
     * @param projectId 项目ID
     * @return 预算使用情况数据
     */
    Map<String, Object> getBudgetUsageStat(Long projectId);
    
    /**
     * 获取支出类型分布
     * 
     * @param projectId 项目ID
     * @return 支出类型分布数据
     */
    Map<String, Object> getExpenseTypeDistribution(Long projectId);
    
    /**
     * 获取月度支出趋势
     * 
     * @param projectId 项目ID
     * @param year 年份
     * @return 月度支出趋势数据
     */
    Map<String, Object> getMonthlyExpenseTrend(Long projectId, String year);
    
    /**
     * 获取支出审批统计
     * 
     * @param projectId 项目ID
     * @return 支出审批统计数据
     */
    Map<String, Object> getExpenseApprovalStat(Long projectId);
} 