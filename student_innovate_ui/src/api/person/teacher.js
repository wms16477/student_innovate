import request from '@/utils/request'

// 查询老师列表
export function listTeacher(query) {
  return request({
    url: '/person/teacher/list',
    method: 'get',
    params: query
  })
}

// 根据学校ID查询老师列表
export function listTeacherBySchool(schoolId) {
  return request({
    url: '/person/teacher/list',
    method: 'get',
    params: { schoolId }
  })
}

// 查询老师详细
export function getTeacher(id) {
  return request({
    url: '/person/teacher/' + id,
    method: 'get'
  })
}

// 新增老师
export function addTeacher(data) {
  return request({
    url: '/person/teacher',
    method: 'post',
    data: data
  })
}

// 修改老师
export function updateTeacher(data) {
  return request({
    url: '/person/teacher',
    method: 'put',
    data: data
  })
}

// 删除老师
export function delTeacher(id) {
  return request({
    url: '/person/teacher/' + id,
    method: 'delete'
  })
}

// 导出老师
export function exportTeacher(query) {
  return request({
    url: '/person/teacher/export',
    method: 'post',
    params: query
  })
}

// 获取老师导入模板
export function importTemplate() {
  return request({
    url: '/person/teacher/importTemplate',
    method: 'post',
    responseType: 'blob'
  })
}

// 导入老师数据
export function importData(data) {
  return request({
    url: '/person/teacher/importData',
    method: 'post',
    data: data
  })
}
