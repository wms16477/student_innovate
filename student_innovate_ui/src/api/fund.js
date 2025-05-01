import request from '@/utils/request'

// 审批经费预算
export function approveFundBudget(isApprove, data) {
  return request({
    url: '/web/fundBudget/approve/' + isApprove,
    method: 'post',
    data: data
  })
}

// 学校审批经费预算
export function schoolApproveFundBudget(isApprove, data) {
  return request({
    url: '/web/fundBudget/school-approve/' + isApprove,
    method: 'post',
    data: data
  })
}

// 提交经费预算
export function submitFundBudget(id) {
  return request({
    url: '/web/fundBudget/submit/' + id,
    method: 'put'
  })
}

// 审批经费支出
export function approveFundExpense(isApprove, data) {
  return request({
    url: '/web/fundExpense/approve/' + isApprove,
    method: 'post',
    data: data
  })
}

// 学校审批经费支出
export function schoolApproveFundExpense(isApprove, data) {
  return request({
    url: '/web/fundExpense/school-approve/' + isApprove,
    method: 'post',
    data: data
  })
}

// 提交经费支出
export function submitFundExpense(id) {
  return request({
    url: '/web/fundExpense/submit/' + id,
    method: 'put'
  })
}

// 标记经费支出为已支付
export function markAsPaidFundExpense(id) {
  return request({
    url: '/web/fundExpense/markAsPaid/' + id,
    method: 'put'
  })
}
