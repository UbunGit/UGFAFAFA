<template>
<el-tabs type="border-card">
  <el-tab-pane label="策略验证">
    <main-view ></main-view>
  </el-tab-pane>
  <el-tab-pane label="及时选股">
    <choose> </choose>
  </el-tab-pane>
</el-tabs>
</template>

<script>
import mainView from "@/view/main";
import choose from "@/view/choose";
  export default {
    components: { mainView,choose },
  }
</script>