<template>
  <div>
    <div slot="header" class="clearfix">
      <span>新增/修改策略</span>
    </div>
    <el-form ref="form" :model="tactic" label-width="80px" class="table">
      <el-form-item label="策略名称">
        <el-input v-model="tactic.name"></el-input>
      </el-form-item>
      <el-form-item label="策略描述">
        <el-input type="textarea" v-model="tactic.doc"></el-input>
      </el-form-item>
      <el-form-item label="文件名">
        <el-input v-model="tactic.source"></el-input>
      </el-form-item>

      <el-form-item label="代码">
        <el-input type="textarea" v-model="tactic.code"></el-input>
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="onSubmit">确定</el-button>
        <el-button>取消</el-button>
      </el-form-item>
    </el-form>

    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>入参数列表</span>
        <el-button
          style="float: right; padding: 3px 0"
          type="text"
          @click="handleCreateParam()"
          >新增</el-button
        >
      </div>

      <el-table :data="tactic.params" stripe style="width: 100%">
        <el-table-column prop="name" label="名称" width="180">
        </el-table-column>
        <el-table-column prop="doc" label="描述"> </el-table-column>
        <el-table-column align="right">
          <template slot-scope="scope">
            <el-button
              size="mini"
              @click="handleCreateParam(scope.$index, scope.row)"
              >编辑</el-button
            >
            <el-button
              size="mini"
              type="danger"
              @click="handleDelete(scope.$index, scope.row)"
              >删除</el-button
            >
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog :visible.sync="dialogVisible">
      <param-edit
        :paramId="paramId"
        :tacticsId="tactic.id"
        @saveSuccess="loadData"
      ></param-edit>
    </el-dialog>
  </div>
</template>

<script>
import { detailed as tactic, update } from "@/api/tactucs";

import ParamEdit from "@/views/ParamEdit";
export default {
  components: { ParamEdit },
  created() {
    this.loadData();
  },
  data() {
    return {
      tactic: {
        id: 0,
        name: "",
        source: "",
        doc: "",
        params: [],
      },
      paramId: 0,
      dialogVisible: false,
    };
  },
  methods: {
    loadData() {
       this.dialogVisible = false
      tactic(this.$route.query.id)
        .then((response) => {
          this.tactic = response.data;
        })
        .catch(() => {});
    },
    onSubmit() {
      update(this.tactic)
        .then((response) => {
            this.$message("保存成功");
        })
        .catch((error) => {
          this.$message(JSON.stringify(error));
        });
    },
 
    handleCreateParam(row) {
      if (row != null) {
        this.paramId = this.tactic.params[row].id;
      } else {
        this.paramId = 0;
      }
      this.dialogVisible = true;
    },
  },
};
</script>

<style scoped>
.table {
  margin-top: 10px;
}
</style>

