<template>
  <div>
    <van-tabbar v-model="active" @change="onChange">
     <TabbarItem v-for="route in routes" :key="route.path" :item="route"></TabbarItem>
    </van-tabbar>
   
  </div>
</template>

<script>
import TabbarItem from './TabbarItem'

export default {
  components: { TabbarItem },
  computed: {
    routes() {
      return this.$router.options.routes;
    },
    activeMenu() {
      const routes = this.$route;
      const { meta, path } = routes;
      if (meta.activeMenu) {
        return meta.activeMenu;
      }
      return path;
    },

    isCollapse() {
      return false;
      // return !this.sidebar.opened
    },
  },
  data() {
    return {
      active: 'home',
    };
  },
  methods: {
    onChange(index) {
      //   Notify({ type: "primary", message: index });
    },
  },
};
</script>
<style>
.scrollbar-wrapper {
  overflow-x: hidden;
}
</style>