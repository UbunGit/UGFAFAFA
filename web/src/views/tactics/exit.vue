<template>
  <div>
    <div slot="header" class="clearfix">
      <span>回测分析</span>
    </div>

    <el-form :model="data" label-width="80px" class="form-param" size="mini">

      <el-row :gutter="20">
        <el-col :span="10" v-for="item in data.params"
            :key="item.id">
          <el-form-item
            :label="item.name"
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

      <el-form-item>
        <el-button type="primary" @click="onSubmit" :loading="loading">执行</el-button>
      </el-form-item>
    </el-form>
  <div>

    <!-- BS K线图 -->
    <BS-echarts v-model="result" :points="points" @select="emit_dayinfo"></BS-echarts>
   
    <el-tabs tab-position="top">
    <el-tab-pane label="每日详情">
      {{dayinfo}}
    </el-tab-pane>

    <el-tab-pane label="BS 记录">
      <el-table :data="outcome.line" size="mini">
            <el-table-column prop="id" label="id" width="50"></el-table-column>
            <el-table-column
              prop="num"
              label="数量"
              width="50"
            ></el-table-column>
            <el-table-column prop="bdate" label="购买日期" >
            </el-table-column>
            <el-table-column prop="bprice" label="购买价格" >
            </el-table-column>
            <el-table-column prop="inday" label="持仓天数" >
            </el-table-column>
            <el-table-column prop="sprice" label="卖出价格" >
            </el-table-column>
            <el-table-column prop="sdate" label="卖出时间">
            </el-table-column>
            <el-table-column prop="fee" label="手续费">
            </el-table-column>
          </el-table>
      
    </el-tab-pane>

    <el-tab-pane label="BS K线图">
      {{outcome}}
    </el-tab-pane>

  </el-tabs>
  </div>

 
    
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
      dayinfo:{},
      outcome:{
        last:{},
        line:[]
      }, //最终结果

    };
  },
  sockets: {
    connect: function () {
      console.log("socket connected");
    },
    message: function (val) {
      this.outcome.last=val
      this.result.push(val);
      this.getbsPoint(val);
    },
    error: function (val) {
      this.$message.error(val);
      this.loading = false
    },
    finesh: function (val) {
      this.$message.info("结束");
      this.outcome.line=val["line"]
      this.loading = false
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
      this.loading = true
      this.result = [];
      this.points = [];
      var data = {};
      var param = {};
      for (var index in this.data.params) {
        var item = this.data.params[index];
        param[item.title] = item.defual;
      }
      data["id"] = this.data.id;
      data["param"] = param;
      this.$socket.emit("message", data);
    },
    emit_dayinfo(val){

      this.dayinfo= val
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