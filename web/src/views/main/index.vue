<template>
  <div>
    <van-tabs v-model="active" scrollspy sticky>
      <van-tab title="源码">
        <code-view ref="codeView" type="primary" v-model="formdata.code"></code-view>
      </van-tab>

      <van-tab title="入参">
        <tactics-inputView ref="inputView"></tactics-inputView>
      </van-tab>
 
      <van-tab title="结果">
        <result-view v-model="result" v-loading="loading" @runexit="runexit"></result-view>
      </van-tab>
    </van-tabs>

    <el-footer>
            <el-input
              type="textarea"
              placeholder="请输入内容"
              v-model="result"
              style="height:100%;"
            ></el-input>
          </el-footer>

  </div>
</template>
<script>

import ResultView from "./components/ResultView";
import CodeView from "./components/CodeView";
import TacticsInputView from "./components/TacticsInputView";

import { runexit } from "@/api/share";
import { detailed as tacticsdetailed,exit as tactucexit } from "@/api/tactucs";


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
      },
      result: null,
      drawer: false,
      direction: "ltr"
    };
  },
  methods: {
    onSubmit() {},

    runexit() {
      let chil = this.$refs.inputView;
      var temdata = {};
      for (const i in chil.inputs) {
        let item = chil.inputs[i];
        temdata[item.name] = item.value;
      }

      this.loading = true;
      this.result = null;
      tactucexit({"id":this.$route.query.id,"argv":JSON.stringify(temdata)})
        .then(response => {
          this.result = response;
          this.loading = false;
        })
        .catch(error => {
          this.loading = false;
          alert(JSON.stringify(error));
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