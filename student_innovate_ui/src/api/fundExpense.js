import request from '@/utils/request'

// 查询经费支出列表
export function listFundExpense(query) {
  return request({
    url: '/web/fundExpense/list',
    method: 'get',
    params: query
  })
}

// 查询经费支出详细
export function getFundExpense(id) {
  return request({
    url: '/web/fundExpense/' + id,
    method: 'get'
  })
}

// 新增经费支出
export function addFundExpense(data, submit) {
  return request({
    url: '/web/fundExpense',
    method: 'post',
    data: data,
    params: {
      submit: submit
    }
  })
}

// 修改经费支出
export function updateFundExpense(data, submit) {
  return request({
    url: '/web/fundExpense',
    method: 'put',
    data: data,
    params: {
      submit: submit
    }
  })
}

// 删除经费支出
export function delFundExpense(id) {
  return request({
    url: '/web/fundExpense/' + id,
    method: 'delete'
  })
}

// 提交经费支出
export function submitFundExpense(id) {
  return request({
    url: '/web/fundExpense/submit/' + id,
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

// 标记为已支付
export function markAsPaidFundExpense(id) {
  return request({
    url: '/web/fundExpense/markAsPaid/' + id,
    method: 'put'
  })
} 