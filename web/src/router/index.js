import Vue from 'vue'
import Router from 'vue-router'
import Layout from '@/views/layout'


Vue.use(Router)
export const constantRouterMap = [
  {
    path: '/',
    name: 'main',
    component: Layout,
    meta: { title: '自选股', icon: 'el-icon-grape' },
    children: [
      {
        path: 'tactics',
        name: '策略',
        component: () => import('@/views/tactics'),
        meta: { title: '策略', icon: 'el-icon-grape' }
      },
      {
        path: 'main',
        name: '我的策略',
        component: () => import('@/views/main'),
        meta: { title: '我的策略', icon: 'el-icon-grape' }
      },
 
      
      {
        path: 'choose',
        name: '今日推荐',
        component: () => import('@/views/choose'),
        meta: { title: '今日推荐', icon: 'el-icon-grape' }
      },
      {
        path: 'test',
        name: 'test',
        component: () => import('@/views/test'),
        meta: { title: '测试', icon: 'el-icon-grape' }
      },
    ]
  },
  {
    path: '/tactic',
    name: 'main',
    component: Layout,
    meta: { title: '交易策略', icon: 'el-icon-grape' },
    children: [
      {
        path: 'list',
        name: '交易策略',
        component: () => import('@/views/tactics'),
        meta: { title: '策略', icon: 'el-icon-grape' }
      },
      {
        path: 'setting',
        name: '修改/新增交易策略',
        component: () => import('@/views/tactics/components/setting'),
        meta: { title: '交易策略设置', icon: 'el-icon-grape' }
      },
    ]
  },
  {
    path: '/test',
    name: 'main',
    component: Layout,
    meta: { title: '测试', icon: 'el-icon-grape' },
    children: [
      {
        path: 'test',
        name: 'test',
        component: () => import('@/views/test'),
        meta: { title: '测试', icon: 'el-icon-grape' }
      },
     
    ]
  },

]
export default new Router({
  routes: constantRouterMap

})
