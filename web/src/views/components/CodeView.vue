<template>
  <div>
    <van-cell>
       <div style="float:right">
        <van-button icon="envelop-o" text="保存" size="mini"  @click="onSave"/>
      </div>
    </van-cell>
     <el-input  type="textarea" class="code-view" v-model="code"></el-input>
  </div>
</template>

<script>
import "codemirror/theme/ambiance.css";
import "codemirror/lib/codemirror.css";

let CodeMirror = require("codemirror/lib/codemirror");
require("codemirror/mode/python/python.js");

import { update as tactucsupdate} from "@/api/tactucs";

export default {
  name: "CodeView",
  props: {
    value: null
  },
  watch: {
    value: {
      handler(newValue, oldValue) {
        this.code = this.value;
      },
      immediate: true
    },
    code: {
      handler(newValue, oldValue) {},
      immediate: true
    }
  },
  data() {
    return {
      code: null,
      inputs: []
    };
  },
 
  methods: {
    runexit() {
      this.$emit("runexit", this.code);
    },
    onSave(){
        tactucsupdate({"id":this.$route.query.id,"code":this.code})
        .then(response => {
          console.log(response)
        })
        .catch(error => {
          this.$message.error(JSON.stringify(error));
        });
    }
  }  
};
</script>

<style>

</style>
