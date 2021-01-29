<template>
  <div>
    <van-field
      v-model="data.title"
      name="用户名"
      label="名称"
      placeholder="请输入用户名"
    />
    <van-field
      v-model="data.name"
      name="用户名"
      label="属性名"
      placeholder="请输入对应的属性名"
    />
    <van-field
      v-model="data.defual"
      name="用户名"
      label="默认值"
      placeholder="请输入默认值"
    />
    <van-field
      readonly
      clickable
      name="picker"
      :value="data.type"
      label="入参类型"
      placeholder="点击选择入参类型"
      @click="showPicker = true"
    />
    <div style="margin: 16px">
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
import { inputdetailed, inputupdate } from "@/api/tactucs";

export default {
  props: {
    paramId:0,
    tacticsId:0
  },
  watch: {
    paramId:{
      handler(newvalue, oldvalue){
        this.getinputDetaile(newvalue);
      },
      immediate: true
    }
  },

  data() {
    return {
      data: {
        id:0,
        type: "text",
        tacticsId: this.tacticsId,
      },
      columns: ["text", "date"],
      showPicker: false,
    };
  },
 
  methods: {
    getinputDetaile(val) {
      if (val == null || val == 0) {
        return;
      }
      inputdetailed(val)
        .then((response) => {
    
          this.data = response.data;
        })
        .catch((error) => {
          this.$message.error(error);
        });
    },
    onConfirm() {
      if (this.tacticsId == null) {
        this.$message("请选择策略");
        return;
      }
      this.data.id = this.paramId
      this.data.tacticsId = this.tacticsId
      
      inputupdate(this.data)
        .then((response) => {
          this.$message("成功");
          this.$emit("saveSuccess")
        })
        .catch((error) => {
          this.$message(JSON.stringify(error));
        });
    },
    onselect(value) {
      this.data.type = value;
      this.showPicker = false;
    },
  },
};
</script>