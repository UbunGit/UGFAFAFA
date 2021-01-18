<template>
  <div>
    <div slot="header" class="clearfix">
    <span>交易策略</span>
    <el-button style="float: right; padding: 3px 0" type="text">新增</el-button>
  </div>
    <el-table
      :data="
        list.filter(
          (data) =>
            !search || data.name.toLowerCase().includes(search.toLowerCase())
        )
      "
      stripe
      style="width: 100%"
    >
      <el-table-column prop="name" label="名称" width="180"> </el-table-column>
      <el-table-column prop="doc" label="描述"> </el-table-column>
      <el-table-column align="right">
        <template slot="header" slot-scope="scope" >
          <el-input v-model="search" size="mini" placeholder="输入关键字搜索" />
        </template>
        <template slot-scope="scope">
          <el-button size="mini" @click="handleEdit(scope.$index, scope.row)"
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
    <div class="footer">
        <el-pagination layout="prev, pager, next" :total="list.length" > </el-pagination>
    </div>
  </div>
</template>

<script>
import { list as tactucsList } from "@/api/tactucs";

export default {
  created() {
    this.onLoad();
  },
  data() {
    return {
      list: [],
      search: null,
      loading: false,
      finished: false,
      refreshing: false,
    };
  },
  methods: {
    onLoad() {
      // if (this.refreshing) {
      //   this.list = [];
      // }
      tactucsList()
        .then((response) => {
          console.log(response);
          // this.refreshing = false;
          this.list = response.data;
          // this.loading = false;
          // this.finished = true;
        })
        .catch((error) => {
          this.$message.error(error);
        });
    },
    onRefresh() {

    },
    handleEdit(row) {

      var trace = this.list[row]
      this.$router.push({ path: "/tactic/setting?id=" + trace.id });
    },
    handleDelete(row){
      this.$confirm('此操作将永久删除策略, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$message({
            type: 'success',
            message: '删除成功!'
          });
        }).catch(() => {
          this.$message({
            type: 'info',
            message: '已取消删除'
          });          
        });
    }
  },
};
</script>

<style scoped>

.footer {
  margin: 10px;
}

</style>

