<template>
  <el-container>
    <el-aside :width="asidewidth">
       <el-button icon="el-icon-s-help" @click="reviewaside" ></el-button>
      <el-menu 
      :default-active="$router.path"
      class="el-menu-vertical-demo"
      router>
        <el-menu-item index="/main">
          <i class="el-icon-menu"></i>
          <span slot="title">我的策略</span>
        </el-menu-item>
        <el-menu-item index="/choose">
          <i class="el-icon-setting"></i>
          <span slot="title">选股</span>
        </el-menu-item>
        <el-menu-item index="/setting">
          <i class="el-icon-setting"></i>
          <span slot="title">设置</span>
        </el-menu-item>
             <el-menu-item index="/test">
          <i class="el-icon-setting"></i>
          <span slot="title">测试</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <router-view />
    </el-container>
  </el-container>
</template>

<script>
export default {
  data() {
    return {
      ishidden: false,
      asidewidth:"150px"
    }
  },
   methods: {
    reviewaside() {
      this.ishidden = !this.ishidden;
      if(this.ishidden){
        this.asidewidth="50px"
      }else{
        this.asidewidth="150px"
      }
      
    },
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