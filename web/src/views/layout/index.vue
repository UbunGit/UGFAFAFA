<template>
  <div>
    <sidebar class="sidebar" v-if="screenWidth>720"/>
    <tabbar class="tabbar" v-if="screenWidth<=720"></tabbar>
    <div :class='(screenWidth>720)?"sidebar-container":"tab-container"'>
      <el-card class="box-card">
        <router-view />
      </el-card>
    </div>
  </div>
</template>

<script>
import  Sidebar  from "./components/Sidebar";
import  tabbar  from './components/tabbar'
export default {
  components: {
    Sidebar,tabbar
  },
  computed: {
    routes() {
      return this.$router.options.routes;
    },
  },
  mounted() {
    const that = this;
    window.onresize = () => {
      return (() => {
        window.screenWidth = document.body.clientWidth;
        that.screenWidth = window.screenWidth;
      })();
    };
  },
  watch: {
    screenWidth(val) {
      // 为了避免频繁触发resize函数导致页面卡顿，使用定时器
      if (!this.timer) {
        // 一旦监听到的screenWidth值改变，就将其重新赋给data里的screenWidth
        this.screenWidth = val;
        this.timer = true;
        let that = this;
        setTimeout(function () {
          // 打印screenWidth变化的值
          console.log(that.screenWidth);
          that.timer = false;
        }, 400);
      }
    },
  },
  data() {
    return {
      show: false,
      screenWidth: document.body.clientWidth
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
.sidebar{
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
.sidebar-container {
  min-height: 100%;
  transition: margin-left 0.28s;
  margin-left: 220px;
  position: relative;
}
.box-card {
  margin: 8px;
}
</style>