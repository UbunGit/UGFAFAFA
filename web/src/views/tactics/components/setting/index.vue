<template>
  <div>
    <el-form ref="form" :model="tactic" label-width="80px">
      <el-form-item label="策略名称">
        <el-input v-model="tactic.name"></el-input>
      </el-form-item>
      <el-form-item label="策略描述">
        <el-input type="textarea" v-model="tactic.doc"></el-input>
      </el-form-item>
      <el-form-item label="策略代码">
        <el-input type="textarea" v-model="tactic.source"></el-input>
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="onSubmit">立即创建</el-button>
        <el-button>取消</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
import { detailed as tactic, update } from "@/api/tactucs";

import CodeView from "@/views/components/CodeView";
export default {
  components: { CodeView },
  created() {
    tactic(this.$route.query.id).then((response) => {
      this.tactic = response.data;
    });
  },
  data() {
    return {
      tactic: {
        id: 0,
        name: "",
        source: "",
        doc: "",
      },
    };
  },
  methods: {
    onSubmit() {
      update(this.tactic)
        .then((response) => {
          this.tactic = response.data;
        })
        .catch((error) => {
          alert(JSON.stringify(error));
        });
    },
  },
};
</script>

<style scoped>
</style>

