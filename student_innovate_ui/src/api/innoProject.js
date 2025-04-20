import request from '@/utils/request'

// 查询大创项目列表
export function listInnoProject(query) {
  return request({
    url: '/web/innoProject/list',
    method: 'get',
    params: query
  })
}

// 查询大创项目详细
export function getInnoProject(id) {
  return request({
    url: '/web/innoProject/' + id,
    method: 'get'
  })
}

// 新增大创项目
export function addInnoProject(data, submit) {
  return request({
    url: '/web/innoProject',
    method: 'post',
    data: data,
    params: {
      submit: submit
    }
  })
}

// 修改大创项目
export function updateInnoProject(data, submit) {
  return request({
    url: '/web/innoProject',
    method: 'put',
    data: data,
    params: {
      submit: submit
    }
  })
}

// 删除大创项目
export function delInnoProject(id) {
  return request({
    url: '/web/innoProject/' + id,
    method: 'delete'
  })
}

// // 提交大创项目
// export function submitInnoProject(id) {
//   return request({
//     url: '/web/innoProject/submit/' + id,
//     method: 'put'
//   })
// }
