import request from '@/utils/request'

// 获取项目经费总体概况
export function getFundOverview(projectId) {
  return request({
    url: '/web/fundAnalysis/overview',
    method: 'get',
    params: { projectId }
  })
}

// 获取预算使用情况
export function getBudgetUsage(projectId) {
  return request({
    url: '/web/fundAnalysis/budgetUsage',
    method: 'get',
    params: { projectId }
  })
}

// 获取支出类型分布
export function getExpenseTypeDistribution(projectId) {
  return request({
    url: '/web/fundAnalysis/expenseTypeDistribution',
    method: 'get',
    params: { projectId }
  })
}

// 获取月度支出趋势
export function getMonthlyExpenseTrend(projectId, year) {
  return request({
    url: '/web/fundAnalysis/monthlyExpenseTrend',
    method: 'get',
    params: { projectId, year }
  })
}

// 获取支出审批统计
export function getExpenseApprovalStat(projectId) {
  return request({
    url: '/web/fundAnalysis/expenseApprovalStat',
    method: 'get',
    params: { projectId }
  })
} 