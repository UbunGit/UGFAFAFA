// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';

import VCharts from 'v-charts'
import App from './App'
import router from './router'


import Vant from 'vant';
// import '@vant/touch-emulator';
import 'vant/lib/index.css';


Vue.use(VCharts)
Vue.use(ElementUI);
Vue.use(Vant);
Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>'
})
