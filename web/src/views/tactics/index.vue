<template>
  <div>
    <el-table
      :data="
        list.filter(
          (data) =>
            !search || data.name.toLowerCase().includes(search.toLowerCase())
        )
      "
      stripe
      style="width: 100%"
      @row-click="onpush()"
    >
      <el-table-column prop="name" label="名称" width="180"> </el-table-column>
      <el-table-column prop="doc" label="描述"> </el-table-column>
      <el-table-column align="right">
        <template slot="header" slot-scope="scope">
          <el-input v-model="search" size="mini" placeholder="输入关键字搜索" />
        </template>
        <template slot-scope="scope">
          <el-button size="mini" @click="handleEdit(scope.$index, scope.row)"
            >Edit</el-button
          >
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.$index, scope.row)"
            >Delete</el-button
          >
        </template>
      </el-table-column>
    </el-table>
    <div class="footer">
      <el-pagination layout="prev, pager, next" :total="50"> </el-pagination>
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
      // 清空列表数据
      // this.finished = false;
      // // 重新加载数据
      // // 将 loading 设置为 true，表示处于加载状态
      // this.loading = true;
      // this.onLoad();
    },
    onpush(id) {
      this.$router.push({ path: "/main?id=" + id });
    },
  },
};
</script>

<style scoped>
.footer {
  margin: 10px;
}
</style>

