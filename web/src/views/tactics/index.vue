<template>
  <div>
    <van-pull-refresh v-model="refreshing" @refresh="onRefresh">
      <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">
        <van-cell v-for="item in list" :key="item" :title="item.name" @click="onpush(item.id)" />
      </van-list>
    </van-pull-refresh>
    <footer class="footer">
        <van-button class="bottom" type="primary" block @click="onpush()">新增策略</van-button>
    </footer>
    
  </div>
</template>

<script>
import { list as tactucsList } from "@/api/tactucs";

export default {
  data() {
    return {
      list: [],
      loading: false,
      finished: false,
      refreshing: false,
    };
  },
  methods: {
    onLoad() {
        if (this.refreshing) {
          this.list = [];
        }
        tactucsList().then(response => {

            this.refreshing = false;
            this.list = response
            this.loading = false;
            this.finished = true;
          
        });
  
    },
    onRefresh() {
      // 清空列表数据
      this.finished = false;

      // 重新加载数据
      // 将 loading 设置为 true，表示处于加载状态
      this.loading = true;
      this.onLoad();
    },
    onpush(id){

        this.$router.push({ path: '/main?id='+id});
    }
  },
};
</script>
<style scoped>
.footer{
    position:absolute;
    bottom:10px;
    left:10px;
    right:10px;
}
</style>

