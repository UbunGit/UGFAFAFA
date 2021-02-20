import Vue from 'vue'
import Router from 'vue-router'
import Layout from '@/views/layout'


Vue.use(Router)
export const constantRouterMap = [
  {
    path: '/',
    name: 'main',
    component: Layout,
    meta: { title: '模拟', icon: 'el-icon-grape' },
    children: [

      {
        path: '',
        name: 'K线模拟',
        component: () => import('@/views/simulation'),
        meta: { title: 'K线模拟', icon: 'el-icon-grape' }
      },


      {
        path: 'choose',
        name: '今日推荐',
        component: () => import('@/views/choose'),
        meta: { title: '今日推荐', icon: 'el-icon-grape' }
      },

    ]
  },
  {
    path: '/tactic',
    name: 'tactic',
    component: Layout,
    meta: { title: '交易策略', icon: 'el-icon-grape' },
    children: [
      {
        path: '',
        name: '交易策略',
        component: () => import('@/views/tactics'),
        meta: { title: '策略', icon: 'el-icon-grape' }
      },
      {
        path: 'setting',
        name: '修改/新增交易策略',
        component: () => import('@/views/tactics/components/setting'),
        meta: { title: '修改/新增交易策略', icon: 'el-icon-grape' },
        hidden: true
      },
      {
        path: 'exit',
        name: '策略回测',
        component: () => import('@/views/tactics/exit'),
        meta: { title: '策略回测', icon: 'el-icon-grape' },
        hidden: true
      },
    ]
  },
  {
    path: '/test',
    name: 'test',
    component: Layout,
    meta: { title: '测试', icon: 'el-icon-grape' },
    children: [
      {
        path: '/test',
        name: 'test1',
        component: () => import('@/views/test'),
        meta: { title: '测试', icon: 'el-icon-grape' }
      },
      {
        path: '/tabbarMenu',
        name: 'tabbarMenu',
        component: () => import('@/views/layout/components/tabbar/TabbarMenu'),
        meta: { title: '菜单', icon: 'el-icon-grape' },
        hidden: true
      },
    ]
  },

 


]
export default new Router({
  routes: constantRouterMap

})
