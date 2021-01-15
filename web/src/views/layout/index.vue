<template>
  <div>
    <van-nav-bar title="标题">
      <template #left>
        <van-button icon="star-o" round @click="showPopup" />
      </template>
    </van-nav-bar>

    <van-popup
      v-model="show"
      position="top"
      closeable
      close-icon-position="top-left"
      :style="{ height: '90%' }"
    >
      <van-cell v-for="item in routes" :key="item.path">
        <h2>{{ item.meta.title }}</h2>
        <van-grid>
          <van-grid-item
            :icon="citem.meta.icon"
            :text="citem.meta.title"
            @click="topath(citem.path)"
            v-for="citem in item.children"
            :key="citem.path"
          ></van-grid-item>
        </van-grid>
      </van-cell>
    </van-popup>

    <sidebar class="sidebar-container" />
    <div class="main-container">
      <router-view />
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
</style>