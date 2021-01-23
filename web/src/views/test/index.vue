<template>
<div>
  测试
  <el-button type="primary" @click="clickButton">执行</el-button>
</div>
</template>

<script>
export default {
  data(){
      return{
          id:''
      }
  },
  mounted(){
      this.$socket.emit('connect'); //在这里触发connect事件
  },
  sockets: {
        connect: function () {
          this.id=this.$socket.id
          console.log('socket connected')
      
        },
        customEmit: function (data) {
          alert("customEmit")
          console.log('this method was fired by the socket server. eg: io.emit("customEmit", data)')
        }
    },
  methods: {
        clickButton: function (data) {
          alert("clickButton")
            this.$socket.emit('emit_method', {"test":"test"})
        }
  }

     
};
</script>