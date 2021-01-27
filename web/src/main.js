// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';

import VCharts from 'v-charts'
import App from './App'
import router from './router'


import Vant from 'vant';
import 'vant/lib/index.css';

import VueSocketIO from 'vue-socket.io'

Vue.use(Vant);
Vue.use(VCharts)
Vue.use(ElementUI);
Vue.use(new VueSocketIO({
  debug: true,
  connection: 'http://127.0.0.1:8081',
  // options: { path: "/" }
}))

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>'
})
