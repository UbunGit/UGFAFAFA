<template>
  <div>
    <sidebar class="sidebar-container" />

    <div class="main-container">
      <el-card class="box-card">
        <router-view />
      </el-card>
    </div>
  </div>
</template>

<script>
import { Sidebar } from "./components";

export default {
  components: {
    Sidebar,
  },
  computed: {
    routes() {
      return this.$router.options.routes;
    },
  },
  data() {
    return {
      show: false,
    };
  },
  methods: {
    showPopup() {
      this.show = true;
    },
    topath(path) {
      this.show = false;
      this.$router.push({ path: path });
    },
  },
};
</script>


<style>
.sidebar-container {
  transition: width 0.28s;
  width: 210px;
  height: 100%;
  position: fixed;
  font-size: 0px;
  top: 0;
  bottom: 0;
  left: 0;
  z-index: 1001;
  overflow: hidden;
}
.main-container {
  min-height: 100%;
  transition: margin-left 0.28s;
  margin-left: 220px;
  position: relative;
}
.box-card{
  margin: 8px;
}
</style>