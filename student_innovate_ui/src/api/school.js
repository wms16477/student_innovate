import request from '@/utils/request'

// 查询学校列表
export function listSchool(query) {
  return request({
    url: '/school/list',
    method: 'get',
    params: query
  })
}

// 查询学校详细
export function getSchool(id) {
  return request({
    url: '/school/' + id,
    method: 'get'
  })
}

// 新增学校
export function addSchool(data) {
  return request({
    url: '/school',
    method: 'post',
    data: data
  })
}

// 修改学校
export function updateSchool(data) {
  return request({
    url: '/school',
    method: 'put',
    data: data
  })
}

// 删除学校
export function delSchool(id) {
  return request({
    url: '/school/' + id,
    method: 'delete'
  })
}

// 获取学校选项
export function getSchoolOptions() {
  return request({
    url: '/school/list',
    method: 'get'
  })
}

// 导出学校
export function exportSchool(query) {
  return request({
    url: '/school/export',
    method: 'post',
    params: query
  })
}

// 获取学校导入模板
export function importTemplate() {
  return request({
    url: '/school/importTemplate',
    method: 'post',
    responseType: 'blob'
  })
}

// 导入学校数据
export function importData(data) {
  return request({
    url: '/school/importData',
    method: 'post',
    data: data
  })
} 