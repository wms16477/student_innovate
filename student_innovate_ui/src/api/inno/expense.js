import request from '@/utils/request'

// 查询支出列表
export function listExpense(query) {
  return request({
    url: '/inno/expense/list',
    method: 'get',
    params: query
  })
}

// 查询支出详细
export function getExpense(id) {
  return request({
    url: '/inno/expense/' + id,
    method: 'get'
  })
}

// 新增支出
export function addExpense(data) {
  return request({
    url: '/inno/expense',
    method: 'post',
    data: data
  })
}

// 修改支出
export function updateExpense(data) {
  return request({
    url: '/inno/expense',
    method: 'put',
    data: data
  })
}

// 删除支出
export function delExpense(id) {
  return request({
    url: '/inno/expense/' + id,
    method: 'delete'
  })
}

// 提交支出
export function submitExpense(id) {
  return request({
    url: '/inno/expense/submit/' + id,
    method: 'put'
  })
}

// 审批支出
export function approveExpense(id, data) {
  return request({
    url: '/inno/expense/approve/' + id,
    method: 'put',
    data: data
  })
}

// 学校审批支出
export function schoolApproveExpense(id, data) {
  return request({
    url: '/inno/expense/school_approve/' + id,
    method: 'put',
    data: data
  })
} 