import request from '@/utils/request'

// 查询经费支付记录列表
export function listFundPayment(query) {
  return request({
    url: '/web/fundPayment/list',
    method: 'get',
    params: query
  })
}

// 查询经费支付记录详细
export function getFundPayment(id) {
  return request({
    url: '/web/fundPayment/' + id,
    method: 'get'
  })
}

// 新增经费支付记录
export function addFundPayment(data) {
  return request({
    url: '/web/fundPayment',
    method: 'post',
    data: data
  })
}

// 删除经费支付记录
export function delFundPayment(id) {
  return request({
    url: '/web/fundPayment/' + id,
    method: 'delete'
  })
} 