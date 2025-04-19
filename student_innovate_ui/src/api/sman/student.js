import request from '@/utils/request'

// 查询测试-学生列表
export function listStudent(query) {
  return request({
    url: '/sman/student/list',
    method: 'get',
    params: query
  })
}

// 查询测试-学生详细
export function getStudent(id) {
  return request({
    url: '/sman/student/' + id,
    method: 'get'
  })
}

// 新增测试-学生
export function addStudent(data) {
  return request({
    url: '/sman/student',
    method: 'post',
    data: data
  })
}

// 修改测试-学生
export function updateStudent(data) {
  return request({
    url: '/sman/student',
    method: 'put',
    data: data
  })
}

// 删除测试-学生
export function delStudent(id) {
  return request({
    url: '/sman/student/' + id,
    method: 'delete'
  })
}
