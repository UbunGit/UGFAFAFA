import axios from 'axios'


// 创建axios实例
const service = axios.create({
    baseURL: 'http://10.10.11.120:5000',
    timeout: 65000 // 请求超时时间
})


// respone拦截器
service.interceptors.response.use(
    response => {
        console.log("response"+JSON.stringify(response))
        const res = response.data
		if(res==undefined){
			console.log("error res==undefined")
			return Promise.reject(response.errMsg)
		}
        if (res.code != 200) {
            console.log("error"+JSON.stringify(res))
            return Promise.reject(res.data)
        } else {
            console.log("scress"+res)
            return res
        }
    },
    error => {
        console.log("service error")
        console.log('err' + error)// for debug
        return Promise.reject(error)
    }
)

//真机获取  
service.defaults.adapter = function (config) {  
    return new Promise((resolve, reject) => {  
        console.log(config)  
        var settle = require('axios/lib/core/settle');  
        var buildURL = require('axios/lib/helpers/buildURL');  
        uni.request({  
            method: config.method.toUpperCase(),  
            url: buildURL(config.url, config.params, config.paramsSerializer),  
            header: config.headers,  
            data: config.data,  
            dataType: config.dataType,  
            responseType: config.responseType,  
            sslVerify: config.sslVerify,  
            complete:function complete(response){  
                response = {  
                  data: response.data,  
                  status: response.statusCode,  
                  errMsg: response.errMsg,  
                  header: response.header,  
                  config: config  
                };  

            settle(resolve, reject, response);  
            }  
        })  
    })  
} 

export default service
