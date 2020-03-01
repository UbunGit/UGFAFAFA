<template>
  <div>
    <el-container>
      <el-header></el-header>
      <el-container>
        <el-aside width="30%">
          <code-view type="primary" v-model="formdata.code" @runexit="runexit"></code-view>
        </el-aside>
        <el-main v-loading="loading">
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
            <result-view v-model="result"></result-view>
          </el-card>
          <el-card>{{result}}</el-card>
        </el-main>
      </el-container>
    </el-container>
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
        amount: 1000,
        tcode: null
      },
      result: null
    };
  },
  methods: {
    onSubmit() {},
    runexit(code) {
      this.loading = true;
      this.formdata.code = code
      const params = new URLSearchParams();
      params.append('code', this.formdata.code);
      params.append('star', this.formdata.star);
      params.append('end', this.formdata.end);
      params.append('amount', this.formdata.amount);
      params.append('tcode', this.formdata.tcode);
      runexit(params).then(response => {
        alert(response);
        this.result = response.data.data;
        this.loading = false;
      });
    }
  }
};
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
}

.el-main {
  background-color: #e9eef3;
  color: #333;
}
</style>