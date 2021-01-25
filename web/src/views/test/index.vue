<template>
  <div>
    <h1>websocket连接</h1>
     <el-button size="mini" @click="clickButton"
            >编辑</el-button>
  </div>
</template>
<script>
export default {
  data() {
    return {
      id: "",
    };
  },
  sockets: {
    connect: function () {
      console.log("socket connected");
    },
    customEmit: function (data) {
      console.log(
        'this method was fired by the socket server. eg: io.emit("customEmit", data)'
      );
    },
  },
  methods: {
    clickButton: function () {
      console.log("clickButton")
      this.$socket.emit("connect", "eeee");
      this.$socket.emit("message", "3333");
    },
  },
  mounted() {
    // this.$socket.emit("connect", "1234567890");
    this.$socket.emit('message',"eeee"); //在这里触发connect事件
  },
};
</script>
<style>
</style>