import request from '@/utils/request'

// 查询学生列表
export function listStudent(query) {
  return request({
    url: '/student/student/list',
    method: 'get',
    params: query
  })
}

// 查询学生选项列表
export function listStudentOptions(query) {
  return request({
    url: '/student/student/options',
    method: 'get',
    params: query
  })
}

// 查询学生详细
export function getStudent(id) {
  return request({
    url: '/student/student/' + id,
    method: 'get'
  })
}

// 新增学生
export function addStudent(data) {
  return request({
    url: '/student/student',
    method: 'post',
    data: data
  })
}

// 修改学生
export function updateStudent(data) {
  return request({
    url: '/student/student',
    method: 'put',
    data: data
  })
}

// 删除学生
export function delStudent(id) {
  return request({
    url: '/student/student/' + id,
    method: 'delete'
  })
}

// 导出学生
export function exportStudent(query) {
  return request({
    url: '/student/student/export',
    method: 'post',
    params: query
  })
}

// 获取学生导入模板
export function importTemplate() {
  return request({
    url: '/student/student/importTemplate',
    method: 'post',
    responseType: 'blob'
  })
}

// 导入学生数据
export function importData(data) {
  return request({
    url: '/student/student/importData',
    method: 'post',
    data: data
  })
}
