import axios from 'axios'

export function configlistAll() {
    axios.defaults.headers.post['Content-Type'] = 'application/json;charset=utf-8';
    return axios.get('http://localhost:9000/api/test?code=1');
  }