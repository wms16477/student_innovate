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

// 审批大创项目
export function approveInnoProject(agree, data) {
  return request({
    url: '/web/innoProject/approve/' + agree,
    method: 'post',
    data: data
  })
}

// 学校审批大创项目
export function schoolApproveInnoProject(agree, data) {
  return request({
    url: '/web/innoProject/school-approve/' + agree,
    method: 'post',
    data: data
  })
}

// 提交中期检查
export function submitMidCheck(data) {
  return request({
    url: '/web/innoProject/midCheck',
    method: 'post',
    data: data
  })
}

// 提交中期检查评分
export function submitMidCheckScore(data) {
  return request({
    url: '/web/innoProject/midCheckScore',
    method: 'post',
    data: data
  })
}

// 计算中期检查总分
export function calculateMidScore(params) {
  return request({
    url: '/web/innoProject/calculateMidScore',
    method: 'get',
    params: params
  })
}

// 提交结项
export function submitEndProject(data) {
  return request({
    url: '/web/innoProject/endProject',
    method: 'post',
    data: data
  })
}

// 提交结项评分
export function submitEndProjectScore(data) {
  return request({
    url: '/web/innoProject/endProjectScore',
    method: 'post',
    data: data
  })
}

// 计算结项总分
export function calculateEndScore(params) {
  return request({
    url: '/web/innoProject/calculateEndScore',
    method: 'get',
    params: params
  })
}

// 获取导入模板
export function importTemplate() {
  return request({
    url: '/web/innoProject/importTemplate',
    method: 'post',
    responseType: 'blob'
  })
}

// 导入数据
export function importData(data) {
  return request({
    url: '/web/innoProject/importData',
    method: 'post',
    data: data
  })
}

