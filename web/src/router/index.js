import Vue from 'vue'
import Router from 'vue-router'
import Layout from '@/views/layout'


Vue.use(Router)
export const constantRouterMap = [
  {
    path: '/',
    component: Layout,
    redirect: '/main',
    children: [{
      path: '/main',
      name: 'main',
      component:  () => import('@/views/main'),
    }]
  },
  {
    path: '/layout',
    name: 'layout',
    component:  Layout,
  },
  {
    path: '/choose',
    component: Layout,
    name: 'choose',
    component: () => import('@/views/choose'),
  },
  {
    path: '/main',
    name: 'main',
    component:  () => import('@/views/main'),
  },

]
export default new Router({
  routes: constantRouterMap
    
})
