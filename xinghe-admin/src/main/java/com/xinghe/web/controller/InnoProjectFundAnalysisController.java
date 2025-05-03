package com.xinghe.web.controller;

import com.xinghe.common.core.controller.BaseController;
import com.xinghe.common.core.domain.AjaxResult;
import com.xinghe.common.utils.StringUtils;
import com.xinghe.web.service.InnoProjectFundAnalysisService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 项目经费分析统计 控制器
 *
 * @author xinghe
 */
@RestController
@RequestMapping("/web/fundAnalysis")
public class InnoProjectFundAnalysisController extends BaseController {

    @Autowired
    private InnoProjectFundAnalysisService analysisService;

    /**
     * 获取项目经费总体概况
     */
    @GetMapping("/overview")
    public AjaxResult getOverview(Long projectId) {
        if (projectId == null) {
            return error("项目ID不能为空");
        }
        return success(analysisService.getProjectFundOverview(projectId));
    }

    /**
     * 获取预算使用情况
     */
    @GetMapping("/budgetUsage")
    public AjaxResult getBudgetUsage(Long projectId) {
        if (projectId == null) {
            return error("项目ID不能为空");
        }
        return success(analysisService.getBudgetUsageStat(projectId));
    }

    /**
     * 获取支出类型分布
     */
    @GetMapping("/expenseTypeDistribution")
    public AjaxResult getExpenseDistribution(Long projectId) {
        if (projectId == null) {
            return error("项目ID不能为空");
        }
        return success(analysisService.getExpenseTypeDistribution(projectId));
    }

    /**
     * 获取月度支出趋势
     */
    @GetMapping("/monthlyExpenseTrend")
    public AjaxResult getMonthlyExpenseTrend(Long projectId, String year) {
        if (projectId == null) {
            return error("项目ID不能为空");
        }
        return success(analysisService.getMonthlyExpenseTrend(projectId, year));
    }

    /**
     * 获取支出审批统计
     */
    @GetMapping("/expenseApprovalStat")
    public AjaxResult getExpenseApprovalStat(Long projectId) {
        if (projectId == null) {
            return error("项目ID不能为空");
        }
        return success(analysisService.getExpenseApprovalStat(projectId));
    }
} 