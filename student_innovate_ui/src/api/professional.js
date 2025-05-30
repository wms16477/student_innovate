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

// 导出专家
export function exportProfessional(query) {
  return request({
    url: '/web/professional/export',
    method: 'post',
    params: query
  })
}

// 获取专家导入模板
export function importTemplate() {
  return request({
    url: '/web/professional/importTemplate',
    method: 'post',
    responseType: 'blob'
  })
}

// 导入专家数据
export function importData(data) {
  return request({
    url: '/web/professional/importData',
    method: 'post',
    data: data
  })
}
