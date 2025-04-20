import request from '@/utils/request'

// 查询专家列表
export function listProfessional(query) {
  return request({
    url: '/web/professional/list',
    method: 'get',
    params: query
  })
}

// 查询专家详细
export function getProfessional(id) {
  return request({
    url: '/web/professional/' + id,
    method: 'get'
  })
}

// 新增专家
export function addProfessional(data) {
  return request({
    url: '/web/professional',
    method: 'post',
    data: data
  })
}

// 修改专家
export function updateProfessional(data) {
  return request({
    url: '/web/professional',
    method: 'put',
    data: data
  })
}

// 删除专家
export function delProfessional(id) {
  return request({
    url: '/web/professional/' + id,
    method: 'delete'
  })
}

// 获取领域列表
export function getAreaList() {
  return request({
    url: '/web/professional/area/list',
    method: 'get'
  })
} 