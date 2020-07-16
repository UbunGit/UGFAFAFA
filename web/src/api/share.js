import axios from 'axios'
axios.defaults.baseURL = 'http://localhost:5000';

export function runexit(data) {
  return axios({
    method: 'post',
    url: '/run',
    data: data,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }
    });
  }
export function sharehistory(data) {

  return axios({
    method: 'get',
    url: '/sharehistory',
    params: data,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }
    });
  }

  export function fitterList(data) {

    return axios({
      method: 'get',
      url: '/fitterList',
      params: data,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }
      });
    }

  

