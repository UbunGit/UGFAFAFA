<template>
  <div>
    <h1>websocket连接</h1>
     <el-button size="mini" @click="clickButton"
            >编辑</el-button>
            <h1>消息列表</h1>
      <div v-for="item in log_list" :key="item.date">  {{item}}  </div> 
  </div>
</template>
<script>
export default {
  data() {
    return {
      id: "",
      msg: "",  
      log_list:[] 
    };
  },
  sockets: {
    connect: function () {
      console.log("socket connected");
    },
     message: function(val){ 

      console.log(new Date()+'返回:'+val);  
      this.log_list.push(val);  
    } 
  },
  methods: {
    clickButton: function () {
      console.log("message")
      this.log_list = []
      this.$socket.emit("message", "test");
    },
  },
  mounted() {
 
  },
};
</script>
<style>
</style>