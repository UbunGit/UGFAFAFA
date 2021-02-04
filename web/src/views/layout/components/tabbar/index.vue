<template>
  <div>
    <van-tabbar v-model="active" @change="onChange">
      <van-tabbar-item  v-for="route in routes" :key="route.path"
      :to="route.path"
      :icon="route.meta.icon"
        >{{route.meta.title}}</van-tabbar-item
      >
    </van-tabbar>
    <!-- <sidebar-item v-for="route in routes" :key="route.path" :item="route" :base-path="route.path" /> -->
  </div>
</template>

<script>
// import { Notify } from "vant";

export default {
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