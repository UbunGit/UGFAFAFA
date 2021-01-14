import axios from 'axios'


// 创建axios实例
const service = axios.create({
    baseURL: process.env.BASE_API, // api的base_url
    timeout: 65000 // 请求超时时间
})


// respone拦截器
service.interceptors.response.use(
    response => {
        console.log(response)
        const res = response.data
        if (res.code != 200) {
            console.log("error"+JSON.stringify(res))
            return Promise.reject(res.data)
        } else {
            console.log("scress"+res)
            return res
        }
    },
    error => {
        alert("service error")
        console.log('err' + error)// for debug
        return Promise.reject(error)
    }
)

export default service
