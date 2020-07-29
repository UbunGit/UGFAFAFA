<template>
  <div>
    <van-tabs v-model="active" scrollspy sticky>
      <van-tab title="入参">
        <tactics-inputView></tactics-inputView>
      </van-tab>
      <van-tab title="源码">
        <code-view ref="codeView" type="primary" v-model="formdata.code"></code-view>
      </van-tab>

      <van-tab title="结果">
        <result-view v-model="result" v-loading="loading"></result-view>
      </van-tab>
    </van-tabs>
    <el-container>
      <el-header>
        <el-upload
          class="upload-demo"
          :show-file-list="false"
          :on-change="handlePreview"
          action
          :auto-upload="false"
          style="float: left;"
          size="small"
        >
          <el-button slot="trigger" icon="el-icon-wallet"></el-button>
          <el-button icon="el-icon-s-help" @click="drawer = true"></el-button>
        </el-upload>
        <el-button-group style="float: right;" size="small">
          <el-button @click="runexit()">运行</el-button>
        </el-button-group>
      </el-header>
      <el-container>
        <el-main>
          <el-card>
            <el-form
              :model="formdata"
              ref="formdata"
              label-width="100px"
              class="demo-ruleForm"
              size="mini"
            >
              <el-col :span="12">
                <el-form-item label="股票代码">
                  <el-input v-model="formdata.tcode"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="初始金额">
                  <el-input v-model="formdata.amount"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="12">
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
              <el-col :span="12">
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
            </el-form>
          </el-card>
          <div></div>
          <el-footer>
            <el-input
              type="textarea"
              placeholder="请输入内容"
              v-model="JSON.stringify(result)"
              style="height:100%;"
            ></el-input>
          </el-footer>
        </el-main>
      </el-container>
    </el-container>


  </div>
</template>
<script>
// import SettingForm from "./components/SettingForm";
import ResultView from "./components/ResultView";
import CodeView from "./components/CodeView";
import TacticsInputView from "./components/TacticsInputView";

import { runexit } from "@/api/share";
import { detailed as tacticsdetailed } from "@/api/tactucs";

export default {
  components: { ResultView, CodeView, TacticsInputView },
  created() {
    tacticsdetailed(this.$route.query.id).then(response => {
      this.formdata.code = response.code;
    });
  },
  data() {
    return {
      active: 0,
      loading: false,
      formdata: {
        code:
          "import pandas, numpy \n\
history = pandas.read_csv('/Users/mba/share/tem/tem.csv') \n\
print(history.to_json(orient='records'))",
        star: "2018-01-01",
        end: new Date(),
        amount: 10000,
        tcode: "000100"
      },
      result: null,
      drawer: false,
      direction: "ltr"
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
      runexit(params)
        .then(response => {
          this.result = response;
          this.loading = false;
        })
        .catch(error => {
          alert(error);
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
    handleClose() {
      this.drawer = true;
    }
  }
};
</script>
<style>

</style>