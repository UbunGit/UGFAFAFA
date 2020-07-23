<template>
  <div>
    <van-nav-bar title="标题">
      <template #left>
        <van-button icon="star-o" round @click="showPopup" />
      </template>
    </van-nav-bar>
    <router-view />

    <van-popup
      v-model="show"
      position="top"
      closeable
      close-icon-position="top-left"
      :style="{ height: '90%' }"
    >
      <van-cell v-for="item in routes" :key="item.path">
        <h2>{{item.meta.title}}</h2>
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
  </div>
</template>

<script>
export default {
  computed: {
    routes() {
      return this.$router.options.routes;
    }
  },
  data() {
    return {
      show: false
    };
  },
  methods: {
    showPopup() {
      this.show = true;
    },
    topath(path) {
      this.show = false;
      this.$router.push({ path: path });
    }
  }
};
</script>
</script>
<style>
.el-aside {
  background-color: #d3dce6;
  color: #333;
}
</style>