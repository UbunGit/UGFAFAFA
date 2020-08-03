import axios from 'axios'


// 创建axios实例
const service = axios.create({
    baseURL: process.env.BASE_API, // api的base_url
    timeout: 65000 // 请求超时时间
})


// respone拦截器
service.interceptors.response.use(
    response => {
        
        const res = response.data
        if (res.code !== 200) {
            return Promise.reject(res.message)
        } else {
            return res.data
        }
    },
    error => {
        alert("service error")
        console.log('err' + error)// for debug
        return Promise.reject(error)
    }
)

export default service
