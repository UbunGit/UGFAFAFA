<template>

<el-container>
  <el-aside width="200px">Aside</el-aside>
  <el-container>
    <router-view/>
  </el-container>
</el-container>
</template>

<script>
// import { AppMain } from './components'
export default {
  // components: {
  //   AppMain
  // },
}
</script>
</script>
<style>


.el-aside {
  background-color: #d3dce6;
  color: #333;
}

</style>