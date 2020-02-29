<template>
  <div>
    <el-container>
      <el-header>Header</el-header>
      <el-container>
        <el-aside width="30%">
          <el-button type="primary">主要按钮</el-button>
        </el-aside>
        <el-main>
          <el-card>
            <setting-form v-model="result"></setting-form>
          </el-card>
          <el-card>
            <result-view v-model="result"></result-view>
          </el-card>
          <el-card></el-card>
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>
<script>
import SettingForm from './components/SettingForm'
import ResultView from './components/ResultView'
import { configlistAll} from "@/api/share";
export default {
     components: { SettingForm,ResultView },
     created() {
      this.onSubmit();
    },
    data() {
        return {
          result:[]
        }
    },
    methods:{
     onSubmit(){
        configlistAll().then(response => {
          this.result = response.data.data

        });
     },
    }
}
</script>
<style>
.el-header,
.el-footer {
  background-color: #b3c0d1;
  color: #333;
  line-height: 60px;
}

.el-aside {
  background-color: #d3dce6;
  color: #333;
  line-height: 200px;
}

.el-main {
  background-color: #e9eef3;
  color: #333;
  line-height: 160px;
}

body > .el-container {
  margin-bottom: 40px;
}

.el-container:nth-child(5) .el-aside,
.el-container:nth-child(6) .el-aside {
  line-height: 260px;
}

.el-container:nth-child(7) .el-aside {
  line-height: 320px;
}
</style>