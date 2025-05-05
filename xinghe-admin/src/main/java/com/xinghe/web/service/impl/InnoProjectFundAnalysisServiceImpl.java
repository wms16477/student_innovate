package com.xinghe.web.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.xinghe.common.utils.StringUtils;
import com.xinghe.web.domain.InnoProjectFundBudget;
import com.xinghe.web.domain.InnoProjectFundExpense;
import com.xinghe.web.domain.InnoProjectFundPayment;
import com.xinghe.web.enums.FundStatusEnum;
import com.xinghe.web.mapper.InnoProjectFundBudgetMapper;
import com.xinghe.web.mapper.InnoProjectFundExpenseMapper;
import com.xinghe.web.mapper.InnoProjectFundPaymentMapper;
import com.xinghe.web.service.InnoProjectFundAnalysisService;
import cn.hutool.core.date.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 项目经费分析统计 服务实现类
 *
 * @author xinghe
 */
@Service
public class InnoProjectFundAnalysisServiceImpl implements InnoProjectFundAnalysisService {

    @Autowired
    private InnoProjectFundBudgetMapper budgetMapper;

    @Autowired
    private InnoProjectFundExpenseMapper expenseMapper;

    @Autowired
    private InnoProjectFundPaymentMapper paymentMapper;

    /**
     * 获取项目经费总体概况
     *
     * @param projectId 项目ID
     * @return 经费总体概况数据
     */
    @Override
    public Map<String, Object> getProjectFundOverview(Long projectId) {
        Map<String, Object> result = new HashMap<>();

        // 预算总额
        BigDecimal totalBudget = getBudgetTotal(projectId);
        result.put("totalBudget", totalBudget);

        // 已支出总额
        BigDecimal totalExpense = getApprovedExpenseTotal(projectId);
        result.put("totalExpense", totalExpense);

        // 预算余额
        BigDecimal remainingBudget = totalBudget.subtract(totalExpense);
        result.put("remainingBudget", remainingBudget);

        // 预算使用率
        BigDecimal usageRate = BigDecimal.ZERO;
        if (totalBudget.compareTo(BigDecimal.ZERO) > 0) {
            usageRate = totalExpense.divide(totalBudget, 4, BigDecimal.ROUND_HALF_UP)
                    .multiply(new BigDecimal("100"));
        }
        result.put("budgetUsageRate", usageRate);

        // 待审批支出总额
        BigDecimal pendingExpense = getPendingExpenseTotal(projectId);
        result.put("pendingExpense", pendingExpense);

        // 待支付总额
        BigDecimal unpaidExpense = getUnpaidExpenseTotal(projectId);
        result.put("unpaidExpense", unpaidExpense);

        return result;
    }

    /**
     * 获取预算使用情况统计
     *
     * @param projectId 项目ID
     * @return 预算使用情况数据
     */
    @Override
    public Map<String, Object> getBudgetUsageStat(Long projectId) {
        Map<String, Object> result = new HashMap<>();

        // 查询所有已批准的预算
        LambdaQueryWrapper<InnoProjectFundBudget> budgetQuery = new LambdaQueryWrapper<>();
        budgetQuery.eq(InnoProjectFundBudget::getProjectId, projectId)
                .eq(InnoProjectFundBudget::getStatus, FundStatusEnum.APPROVED.name());
        List<InnoProjectFundBudget> budgets = budgetMapper.selectList(budgetQuery);

        List<String> budgetNames = new ArrayList<>();
        List<BigDecimal> budgetAmounts = new ArrayList<>();
        List<BigDecimal> usedAmounts = new ArrayList<>();
        List<BigDecimal> remainingAmounts = new ArrayList<>();

        for (InnoProjectFundBudget budget : budgets) {
            budgetNames.add(budget.getBudgetName());
            budgetAmounts.add(budget.getBudgetAmount());

            // 计算该预算已使用金额
            BigDecimal used = budget.getBudgetAmount().subtract(budget.getRemainingAmount());
            usedAmounts.add(used);
            remainingAmounts.add(budget.getRemainingAmount());
        }

        result.put("budgetNames", budgetNames);
        result.put("budgetAmounts", budgetAmounts);
        result.put("usedAmounts", usedAmounts);
        result.put("remainingAmounts", remainingAmounts);

        return result;
    }

    /**
     * 获取支出类型分布
     *
     * @param projectId 项目ID
     * @return 支出类型分布数据
     */
    @Override
    public Map<String, Object> getExpenseTypeDistribution(Long projectId) {
        Map<String, Object> result = new HashMap<>();

        // 查询所有已批准的支出
        LambdaQueryWrapper<InnoProjectFundExpense> expenseQuery = new LambdaQueryWrapper<>();
        expenseQuery.eq(InnoProjectFundExpense::getProjectId, projectId)
                .eq(InnoProjectFundExpense::getStatus, FundStatusEnum.APPROVED.name());
        List<InnoProjectFundExpense> expenses = expenseMapper.selectList(expenseQuery);

        // 按支出类型分组统计
        Map<String, BigDecimal> typeAmountMap = new HashMap<>();
        for (InnoProjectFundExpense expense : expenses) {
            String type = expense.getExpenseType();
            BigDecimal amount = expense.getExpenseAmount();

            if (typeAmountMap.containsKey(type)) {
                typeAmountMap.put(type, typeAmountMap.get(type).add(amount));
            } else {
                typeAmountMap.put(type, amount);
            }
        }

        List<String> types = new ArrayList<>(typeAmountMap.keySet());
        List<BigDecimal> amounts = new ArrayList<>();
        for (String type : types) {
            amounts.add(typeAmountMap.get(type));
        }

        result.put("expenseTypes", types);
        result.put("expenseAmounts", amounts);

        return result;
    }

    /**
     * 获取月度支出趋势
     *
     * @param projectId 项目ID
     * @param year 年份，如果为空则取当前年
     * @return 月度支出趋势数据
     */
    @Override
    public Map<String, Object> getMonthlyExpenseTrend(Long projectId, String year) {
        Map<String, Object> result = new HashMap<>();

        // 如果年份为空，取当前年
        if (StringUtils.isEmpty(year)) {
            year = String.valueOf(DateUtil.year(new Date()));
        }

        // 查询所有已批准的支出
        LambdaQueryWrapper<InnoProjectFundExpense> expenseQuery = new LambdaQueryWrapper<>();
        expenseQuery.eq(InnoProjectFundExpense::getProjectId, projectId)
                .eq(InnoProjectFundExpense::getStatus, FundStatusEnum.APPROVED.name());
        List<InnoProjectFundExpense> expenses = expenseMapper.selectList(expenseQuery);

        // 初始化12个月的数据
        BigDecimal[] monthlyAmounts = new BigDecimal[12];
        for (int i = 0; i < 12; i++) {
            monthlyAmounts[i] = BigDecimal.ZERO;
        }

        // 按月份统计支出金额
        for (InnoProjectFundExpense expense : expenses) {
            Date expenseDate = expense.getExpenseDate();
            if (expenseDate != null) {
                int expenseYear = DateUtil.year(expenseDate);
                if (String.valueOf(expenseYear).equals(year)) {
                    int month = DateUtil.month(expenseDate); // 0-11
                    monthlyAmounts[month] = monthlyAmounts[month].add(expense.getExpenseAmount());
                }
            }
        }

        List<String> months = Arrays.asList("1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月");
        result.put("months", months);
        result.put("amounts", Arrays.asList(monthlyAmounts));
        result.put("year", year);

        return result;
    }

    /**
     * 获取支出审批统计
     *
     * @param projectId 项目ID
     * @return 支出审批统计数据
     */
    @Override
    public Map<String, Object> getExpenseApprovalStat(Long projectId) {
        Map<String, Object> result = new HashMap<>();

        // 查询所有支出
        LambdaQueryWrapper<InnoProjectFundExpense> expenseQuery = new LambdaQueryWrapper<>();
        expenseQuery.eq(InnoProjectFundExpense::getProjectId, projectId);
        List<InnoProjectFundExpense> expenses = expenseMapper.selectList(expenseQuery);

        // 按状态分组统计
        Map<String, Integer> statusCountMap = new HashMap<>();
        Map<String, BigDecimal> statusAmountMap = new HashMap<>();

        for (FundStatusEnum status : FundStatusEnum.values()) {
            statusCountMap.put(status.name(), 0);
            statusAmountMap.put(status.name(), BigDecimal.ZERO);
        }

        for (InnoProjectFundExpense expense : expenses) {
            String status = expense.getStatus();
            BigDecimal amount = expense.getExpenseAmount();

            statusCountMap.put(status, statusCountMap.getOrDefault(status, 0) + 1);
            statusAmountMap.put(status, statusAmountMap.getOrDefault(status, BigDecimal.ZERO).add(amount));
        }

        result.put("statusCounts", statusCountMap);
        result.put("statusAmounts", statusAmountMap);

        // 计算支付情况
        BigDecimal approvedTotal = statusAmountMap.getOrDefault(FundStatusEnum.APPROVED.name(), BigDecimal.ZERO);
        BigDecimal paidTotal = getPaidExpenseTotal(projectId);
        BigDecimal unpaidTotal = approvedTotal.subtract(paidTotal);

        Map<String, BigDecimal> paymentStatus = new HashMap<>();
        paymentStatus.put("paid", paidTotal);
        paymentStatus.put("unpaid", unpaidTotal);

        result.put("paymentStatus", paymentStatus);

        return result;
    }

    /**
     * 获取项目已批准的预算总额
     */
    private BigDecimal getBudgetTotal(Long projectId) {
        LambdaQueryWrapper<InnoProjectFundBudget> query = new LambdaQueryWrapper<>();
        query.eq(InnoProjectFundBudget::getProjectId, projectId)
                .eq(InnoProjectFundBudget::getStatus, FundStatusEnum.APPROVED.name());
        List<InnoProjectFundBudget> budgets = budgetMapper.selectList(query);

        return budgets.stream()
                .map(InnoProjectFundBudget::getBudgetAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * 获取项目已批准的支出总额
     */
    private BigDecimal getApprovedExpenseTotal(Long projectId) {
        LambdaQueryWrapper<InnoProjectFundExpense> query = new LambdaQueryWrapper<>();
        query.eq(InnoProjectFundExpense::getProjectId, projectId);
        List<InnoProjectFundExpense> expenses = expenseMapper.selectList(query);

        return expenses.stream()
                .map(InnoProjectFundExpense::getExpenseAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * 获取项目待审批的支出总额
     */
    private BigDecimal getPendingExpenseTotal(Long projectId) {
        LambdaQueryWrapper<InnoProjectFundExpense> query = new LambdaQueryWrapper<>();
        query.eq(InnoProjectFundExpense::getProjectId, projectId)
                .eq(InnoProjectFundExpense::getStatus, FundStatusEnum.SUBMITTED.name());
        List<InnoProjectFundExpense> expenses = expenseMapper.selectList(query);

        return expenses.stream()
                .map(InnoProjectFundExpense::getExpenseAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * 获取项目已批准但未支付的支出总额
     */
    private BigDecimal getUnpaidExpenseTotal(Long projectId) {
        LambdaQueryWrapper<InnoProjectFundExpense> query = new LambdaQueryWrapper<>();
        query.eq(InnoProjectFundExpense::getProjectId, projectId)
                .eq(InnoProjectFundExpense::getStatus, FundStatusEnum.APPROVED.name());
//                .eq(InnoProjectFundExpense::getIsPaid, false);
        List<InnoProjectFundExpense> expenses = expenseMapper.selectList(query);

        return expenses.stream()
                .map(InnoProjectFundExpense::getExpenseAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * 获取项目已支付的支出总额
     */
    private BigDecimal getPaidExpenseTotal(Long projectId) {
        LambdaQueryWrapper<InnoProjectFundPayment> query = new LambdaQueryWrapper<>();
        query.eq(InnoProjectFundPayment::getProjectId, projectId);
        List<InnoProjectFundPayment> payments = paymentMapper.selectList(query);

        return payments.stream()
                .map(InnoProjectFundPayment::getPaymentAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
