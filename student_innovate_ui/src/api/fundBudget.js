import request from '@/utils/request'

// 查询经费预算列表
export function listFundBudget(query) {
  return request({
    url: '/web/fundBudget/list',
    method: 'get',
    params: query
  })
}

// 查询经费预算详细
export function getFundBudget(id) {
  return request({
    url: '/web/fundBudget/' + id,
    method: 'get'
  })
}

// 新增经费预算
export function addFundBudget(data, submit) {
  return request({
    url: '/web/fundBudget',
    method: 'post',
    data: data,
    params: {
      submit: submit
    }
  })
}

// 修改经费预算
export function updateFundBudget(data, submit) {
  return request({
    url: '/web/fundBudget',
    method: 'put',
    data: data,
    params: {
      submit: submit
    }
  })
}

// 删除经费预算
export function delFundBudget(id) {
  return request({
    url: '/web/fundBudget/' + id,
    method: 'delete'
  })
}

// 提交经费预算
export function submitFundBudget(id) {
  return request({
    url: '/web/fundBudget/submit/' + id,
    method: 'put'
  })
}

// 审批经费预算
export function approveFundBudget(isApprove, data) {
  return request({
    url: '/web/fundBudget/approve/' + isApprove,
    method: 'post',
    data: data
  })
} 