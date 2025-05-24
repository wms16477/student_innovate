import request from '@/utils/request'

// 查询项目列表
export function listProject(query) {
  return request({
    url: '/inno/project/list',
    method: 'get',
    params: query
  })
}

// 查询项目详细
export function getProject(id) {
  return request({
    url: '/inno/project/' + id,
    method: 'get'
  })
}

// 新增项目
export function addProject(data) {
  return request({
    url: '/inno/project',
    method: 'post',
    data: data
  })
}

// 修改项目
export function updateProject(data) {
  return request({
    url: '/inno/project',
    method: 'put',
    data: data
  })
}

// 删除项目
export function delProject(id) {
  return request({
    url: '/inno/project/' + id,
    method: 'delete'
  })
}

// 提交项目
export function submitProject(id) {
  return request({
    url: '/inno/project/submit/' + id,
    method: 'put'
  })
}

// 审批项目
export function approveProject(data) {
  return request({
    url: '/inno/project/approve',
    method: 'put',
    data: data
  })
} 