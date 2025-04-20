import request from '@/utils/request'

// 查询项目类型列表
export function listProjectType() {
  return request({
    url: '/web/innoProject/projectType/list',
    method: 'get'
  })
} 