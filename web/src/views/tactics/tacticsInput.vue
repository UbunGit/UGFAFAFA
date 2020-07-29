<template>
  <div>
    <van-field v-model="inputdata.title" name="用户名" label="名称" placeholder="请输入用户名" />
    <van-field v-model="inputdata.name" name="用户名" label="属性名" placeholder="请输入对应的属性名" />
    <van-field v-model="inputdata.defual" name="用户名" label="默认值" placeholder="请输入默认值" />
    <van-field
      readonly
      clickable
      name="picker"
      :value="inputdata.type"
      label="入参类型"
      placeholder="点击选择入参类型"
      @click="showPicker = true"
    />
    <div style="margin: 16px;">
      <van-button round block type="info" @click="onConfirm()">提交</van-button>
    </div>
    <van-popup v-model="showPicker" position="bottom">
      <van-picker
        show-toolbar
        :columns="columns"
        @confirm="onselect"
        @cancel="showPicker = false"
      />
    </van-popup>
  </div>
</template>
<script>
import { inputdetailed,inputupdate } from "@/api/tactucs";

export default {
  data() {
    return {
      inputdata: {
          "type":"text",
          "tacticsId":this.$route.query.tacticsId
      },
      columns: ["text", "date"],
      showPicker: false
    };
  },
  created() {
      this.getinputDetaile()
  },
  methods: {
    getinputDetaile(){
     
        if(this.$route.query.id == null){
            return
        }
        inputdetailed(this.$route.query.id).then(response => {
            this.inputdata = response
        });
    },
    onConfirm() {

        if(this.$route.query.tacticsId == null){
            this.$notify({ type: 'primary', message: '请选择策略' });
            return;
        }
        inputupdate(this.inputdata).then(response => {
            alert(response)
        });
    },
    onselect(value){
        this.inputdata.type = value
        this.showPicker = false;
    }
  }
};
</script>