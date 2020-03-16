<template>
  <div>
    <el-container>
      <el-header>
          <el-upload
            class="upload-demo"
            :show-file-list="false"
            :on-change="handlePreview"
            action=""
            :auto-upload="false"
            style="float: left;"
            size="small"
          >
            <el-button slot="trigger" icon="el-icon-wallet" ></el-button>
            <el-button icon="el-icon-s-help" @click="drawer = true" ></el-button>
          </el-upload>
          <el-button-group style="float: right;" size="small">
            <el-button @click="runexit()">运行</el-button>
          </el-button-group>
      </el-header>
      <el-container>
        <el-aside width="32%">
          <code-view ref="codeView" type="primary" v-model="formdata.code"></code-view>
        </el-aside>
        <el-main >
          <el-card>
            <el-form
              :model="formdata"
              ref="formdata"
              label-width="100px"
              class="demo-ruleForm"
              size="mini"
            >
              <el-col :span="6">
                <el-form-item label="股票代码">
                  <el-input v-model="formdata.tcode"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="6">
                <el-form-item label="开始时间">
                  <el-date-picker
                    type="date"
                    format="yyyy-MM-dd"
                    value-format="yyyy-MM-dd"
                    placeholder="选择日期"
                    v-model="formdata.star"
                    style="width: 100%;"
                  ></el-date-picker>
                </el-form-item>
              </el-col>
              <el-col :span="6">
                <el-form-item label="结束时间">
                  <el-date-picker
                    type="date"
                    format="yyyy-MM-dd"
                    value-format="yyyy-MM-dd"
                    placeholder="选择日期"
                    v-model="formdata.end"
                    style="width: 100%;"
                  ></el-date-picker>
                </el-form-item>
              </el-col>
              <el-col :span="6">
                <el-form-item label="初始金额">
                  <el-input v-model="formdata.amount"></el-input>
                </el-form-item>
              </el-col>
            </el-form>
          </el-card>
          <el-card>
            <result-view v-model="result" v-loading="loading"></result-view>
          </el-card>
          <el-footer >

            <el-input
            type="textarea"
            placeholder="请输入内容"
            v-model="JSON.stringify(result)"
            style="height:100%;">
          </el-input>
          </el-footer>
        </el-main>
         
      </el-container>
    </el-container>

    <el-drawer
      title="选择策略"
      :visible.sync="drawer"
      :direction="direction"
      :before-close="handleClose"
    >
     <el-card>
    <el-tabs style="height: 200px;">
    <el-tab-pane label="股价">股价</el-tab-pane>
    <el-tab-pane label="MACD">MACD</el-tab-pane>
    <el-tab-pane label="KDJ">KDJ</el-tab-pane>
    <el-tab-pane label="其他">其他</el-tab-pane>
  </el-tabs>
    </el-card>
    </el-drawer>
  </div>
</template>
<script>
// import SettingForm from "./components/SettingForm";
import ResultView from "./components/ResultView";
import CodeView from "./components/CodeView";

import { runexit } from "@/api/share";
export default {
  components: { ResultView, CodeView },
  created() {},
  data() {
    return {
      loading: false,
      formdata: {
        code:
          "import pandas \nhistory = pandas.read_csv('/Users/admin/Documents/github/UGFAFAFA/file/000652.csv', parse_dates=True, index_col=0) \nprint(history.to_json(orient='records'))",
        star: null,
        end: null,
        amount: 10000,
        tcode: '000100',
      },
      result: null,
      drawer: false,
      direction: 'ltr',
    };
  },
  methods: {
    onSubmit() {},
    runexit() {
      this.loading = true;
      this.formdata.code = this.$refs.codeView.code;
      const params = new URLSearchParams();
      params.append("code", this.formdata.code);
      params.append("start", this.formdata.star);
      params.append("end", this.formdata.end);
      params.append("amount", this.formdata.amount);
      params.append("tcode", this.formdata.tcode);
      this.result = null;
      runexit(params).then(response => {
        this.result = response.data.data;
        this.loading = false;
       
      });
    },
    handlePreview(file) {
      var reader = new FileReader();
      reader.onload = () => {
        this.formdata.code = reader.result;
      };
      reader.readAsText(file.raw);
    },
    handleClose(){

    }
  }
};
</script>
<style>
.el-header{
  background-color: #b3c0d1;
  padding: 10pt;
}
.el-footer {
  background-color: #b3c0d1;
  color: #333;
}

.el-aside {
  background-color: #d3dce6;
  color: #333;
  height: 100%;
}

.el-main {
  background-color: #e9eef3;
  color: #333;
}
</style>