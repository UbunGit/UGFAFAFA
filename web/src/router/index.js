import Vue from 'vue'
import Router from 'vue-router'
import Layout from '@/view/layout'


Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/layout',
      name: 'layout',
      component:  Layout,
    },
    {
      path: '/choose',
      component: Layout,
      name: 'choose',
      component: () => import('@/view/choose'),
    },
    {
      path: '/',
      name: 'main',
      component:  () => import('@/view/main'),
    },
  ]
})
