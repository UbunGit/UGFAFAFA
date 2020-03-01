import axios from 'axios'
axios.defaults.baseURL = 'http://localhost:5000';
// axios.defaults.withCredentials = true // 若跨域请求需要带 cookie 身份识别
// axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded';

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

