import axios from 'axios'

export function configlistAll() {
    return axios.get('http://localhost:9000/api/test?code=1');
  }