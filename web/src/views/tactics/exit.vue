<template>
  <div>
    <div slot="header" class="clearfix">
      <span>回测分析</span>
    </div>

    <el-form ref="form" :model="data" label-width="80px" class="table" >
      <el-form-item
        :label="item.name"
        v-for="item in data.params"
        :key="item.id"
      >
        <el-input v-model="item.name"></el-input>
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="onSubmit">执行</el-button>
      </el-form-item>
    </el-form>

     <BS-echarts v-model="result" :points="points"></BS-echarts>

 </div>
</template>

<script>
import { detailed as tactic, exit } from "@/api/tactucs";
import BSEcharts from "./components/BSEcharts";
export default {
  components: { BSEcharts },
  created() {
    this.loadData(this.$route.query.id);
  },
  data() {
    return {
      loading: false,
      data: {},
      result: [],
      points:[]
    };
  },
  sockets: {
    connect: function () {
      console.log("socket connected");
    },
    message: function (val) {
    
      this.result.push(val);
      this.getbsPoint(val)
      
    },
  },
  methods: {
    loadData(tacticId) {
      tactic(tacticId)
        .then((response) => {
          this.data = response.data;
        })
        .catch(() => {});
    },
    onSubmit() {
      this.result = [];
      this.$socket.emit("message", "test");
    },

    getbsPoint(val) {

        var share = val;

        if (share.B.isBuy == true) {
          this.points.push({
            name: "B",
            coord: [share.date, share.B.data.bprice],
            value: "B",
            itemStyle: {
              color: "rgb(255,150,200)",
              fontSize: "4",
            },
          });
        }

        if (share.S.isSeller == true) {
     
          this.points.push({
            name: "S",
            coord: [share.date, share.high],
            value: "S",
            itemStyle: {
              color: "rgb(50,205,200)",
              fontSize: "4px",
            },
          });
        }
     
    },
    
  },
};
</script>