import request from '@/utils/request'

export function runexit(data) {
  return request({
    method: 'post',
    url: '/run',
    data: data,
    });
  }
export function sharehistory(data) {

  return request({
    method: 'get',
    url: '/sharehistory',
    params: data,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }
    });
  }

  export function fitterList(data) {

    return request({
      method: 'get',
      url: '/fitterList',
      params: data,
      });
    }

  

