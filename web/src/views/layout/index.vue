<template>
  <el-container>
    <el-aside width="200px">
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
  
};
</script>
</script>
<style>
.el-aside {
  background-color: #d3dce6;
  color: #333;
}
</style>