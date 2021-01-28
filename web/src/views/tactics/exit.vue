<template>
  <div>
    <div slot="header" class="clearfix">
      <span>回测分析</span>
    </div>

    <el-form :model="data" label-width="80px" class="form-param" >

      <el-row :gutter="20">
        <el-col :span="6" >
          <el-form-item
            :label="item.name"
            v-for="item in data.params"
            :key="item.id"
          >
            <el-date-picker
              v-if="item.type == 'date'"
              v-model="item.defual"
              type="date"
              placeholder="item.defual"
              format="yyyyMMdd"
              value-format="yyyyMMdd"
            >
            </el-date-picker>

            <el-input
              v-if="item.type == 'text'"
              :type="item.type"
              v-model="item.defual"
              value-format="yyyyMMdd"
            ></el-input>
          </el-form-item>
        </el-col>
      </el-row>

  
</el-row>

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
      points: [],
    };
  },
  sockets: {
    connect: function () {
      console.log("socket connected");
    },
    message: function (val) {
      this.result.push(val);
      this.getbsPoint(val);
    },
    error: function (val) {
      this.$message.error(val)
    },
    finesh: function (val) {
      this.$message.error(val)
    }
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
      this.points = [];
      var data = {}
      var param = {};
      for (var index in this.data.params) {
        var item = this.data.params[index];
        param[item.title] = item.defual;
      }
      data["id"]="test"
      data["param"]=param
      alert(JSON.stringify(data))
      this.$socket.emit("message", data);
    },

    getbsPoint(val) {
      var share = val;

      if (share.B.isBuy == true) {
        console.log("isBuy+" + JSON.stringify(share.B));
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
<style>


  .form-param {
    border-radius: 4px;
    padding: 10px 0;
    margin-bottom: 8px;
    background: #f6f7f8;
  }
 
</style>