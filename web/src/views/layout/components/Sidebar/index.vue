<template>
  <div>

    <el-scrollbar wrap-class="scrollbar-wrapper">
      <div>rrrr</div>
      <el-menu
        background-color="#304156"
        text-color="#bfcbd9"
        active-text-color="#409EFF"
        :default-active="activeMenu"
        :collapse="isCollapse"
        :unique-opened="false"
        :collapse-transition="false"
        mode="vertical"
      >
        <sidebar-item v-for="route in routes" :key="route.path" :item="route" :base-path="route.path" />
      </el-menu>
    </el-scrollbar>
  </div>
</template>

<script>

import SidebarItem from './SidebarItem'


export default {
  components: { SidebarItem },

  computed: {
    
    routes() {
      return this.$router.options.routes;
    },
    activeMenu() {
      const routes = this.$route
      const { meta, path } = routes
      if (meta.activeMenu) {
        return meta.activeMenu
      }
      return path
    },

 
    isCollapse() {
      return false
      // return !this.sidebar.opened
    }
  }
}
</script>
<style>
  .scrollbar-wrapper {
      overflow-x: hidden;
}
</style>
