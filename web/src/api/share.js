import axios from 'axios'

export function exeit(code) {
    axios.defaults.headers.post['Content-Type'] = 'application/json;charset=utf-8';
    axios.post('http://localhost:5000/run', {
      code: code,
    })
  }