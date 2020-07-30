<template>
  <div>
    <van-cell>
       <div style="float:right">
        <van-button icon="envelop-o" text="保存" size="mini"  @click="onSave"/>
      </div>
    </van-cell>
    <van-cell>
      <textarea ref="mycode" class="codesql" v-model="code" style="height:300px; width:100%;"></textarea>
    </van-cell>
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
    }
  }  
};
</script>

<style>
.codesql {
  font-size: 11pt;
  font-family: Consolas, Menlo, Monaco, Lucida Console, Liberation Mono,
    DejaVu Sans Mono, Bitstream Vera Sans Mono, Courier New, monospace, serif;
}
</style>
