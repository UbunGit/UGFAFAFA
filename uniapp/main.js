import Vue from 'vue'
import App from './App'

Vue.config.productionTip = false
Vue.prototype.baseUrl = 'http://10.10.11.120:5000'; 
App.mpType = 'app'

const app = new Vue({
    ...App
})
app.$mount()
