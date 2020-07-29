<template>
  <div>
    <van-cell-group title="管理">
      <van-cell>
        <van-tag
          plain
          type="primary"
          closeable
          @close="close(item)"
          @click="handleaddinput(item.id)"
          v-for="item in inputs"
          :key="item.id"
        >{{item.title}}</van-tag>
        <van-tag plain type="primary" @click="handleaddinput()">新增</van-tag>
      </van-cell>
    </van-cell-group>

    <van-cell-group title="入参">
      <van-cell v-for="item in inputs" :key="item.id" size="mini">
        <van-field
          v-model="item.value"
          :label="item.title"
          :placeholder="item.defual"
          v-if="item.type == 'text'"
        />
        <van-field
          readonly
          clickable
          name="calendar"
          :value="item.value"
          label="日历"
          placeholder="点击选择日期"
          @click="handleDate(item)"
          v-if="item.type == 'date'"
        />
      </van-cell>
    </van-cell-group>

    <van-calendar v-model="show" :min-date="minDate" :max-date="maxDate" @confirm="onchageData"/>
  </div>
</template>
<script>
import { inputlist, inputdelete } from "@/api/tactucs";
export default {
  created() {
    this.getinputList();
  },
  data() {
    return {
      inputs: [],
      selectItem:null,
      show: false,
      minDate: new Date(2000, 0, 1),
      maxDate: new Date()
    };
  },
  methods: {
    onchageData(date) {
      this.selectItem.value = date;
      this.show = false;
    },
    getinputList() {
      inputlist(this.$route.query.id).then(response => {
        this.inputs = response;
      });
    },
    handleaddinput(id) {
      if (id) {
        this.$router.push({
          path: "/tacticsinput?id=" + id + "&tacticsId=" + this.$route.query.id
        });
      } else {
        this.$router.push({
          path: "/tacticsinput?tacticsId=" + this.$route.query.id
        });
      }
    },
    handleDate(item){
        this.show = true;
        this.selectItem = item;
    },
    close(item) {
      this.$dialog
        .confirm({
          title: "标题",
          message: "确认删除这个？"
        })
        .then(() => {
          inputdelete(item.id).then(response => {
            this.inputs.pop(item);
          });
        })
        .catch(() => {});
    }
  }
};
</script>