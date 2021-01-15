import Vue from 'vue'
import Router from 'vue-router'
import Layout from '@/views/layout'


Vue.use(Router)
export const constantRouterMap = [
  {
    path: '/',
    name: 'main',
    component: Layout,
    meta: { title: '自选股', icon: 'fire-o' },
    children: [
      {
        path: 'tactics',
        name: '策略',
        component: () => import('@/views/tactics'),
        meta: { title: '策略', icon: 'fire-o' }
      },
      {
        path: 'main',
        name: '我的策略',
        component: () => import('@/views/main'),
        meta: { title: '我的策略', icon: 'fire-o' }
      },
      {
        path: 'tacticsinput',
        name: '策略入参数设置',
        component: () => import('@/views/tactics/tacticsInput'),
        meta: { title: '策略入参数设置', icon: 'fire-o' }
      },
      
      {
        path: 'choose',
        name: '今日推荐',
        component: () => import('@/views/choose'),
        meta: { title: '今日推荐', icon: 'fire-o' }
      },
      {
        path: 'test',
        name: 'test',
        component: () => import('@/views/test'),
        meta: { title: '测试', icon: 'fire-o' }
      },
    ]
  },
  {
    path: '/a',
    name: 'main',
    component: Layout,
    meta: { title: '交易策略', icon: 'fire-o' },
    children: [
      {
        path: 'tactics',
        name: '交易策略',
        component: () => import('@/views/tactics'),
        meta: { title: '策略', icon: 'fire-o' }
      },
    ]
  },
  {
    path: '/test',
    name: 'main',
    component: Layout,
    meta: { title: '测试', icon: 'fire-o' },
    children: [
      {
        path: 'test',
        name: 'test',
        component: () => import('@/views/test'),
        meta: { title: '测试', icon: 'fire-o' }
      },
    ]
  },

]
export default new Router({
  routes: constantRouterMap

})
