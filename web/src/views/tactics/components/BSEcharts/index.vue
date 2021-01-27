<template>
  <div>
    <el-row :gutter="24">
      <el-col :span="16">
        <ve-candle
          :data="chartData"
          :events="chartEvents"
          :settings="chartSettings"
          :mark-point="markPoint"
          :data-zoom="dataZoom"
          :not-set-unchange="['dataZoom']"
        >
        </ve-candle>
      </el-col>
      <el-col :span="8">
        <div v-if="selectDara">
          <p>{{ selectDara.date }}</p>

          <div v-if="selectDara.B">
            <span class="span-msg" v-if="selectDara.B.isBuy == false">
              <i class="el-icon-error">买入失败</i>
              {{ selectDara.B.msg }}
            </span>
            <span class="span-data" v-if="selectDara.B.isBuy == true">
              <i class="el-icon-success">买入</i>
              <p>买入数量：{{ selectDara.B.data.num }}</p>
              <p>买入价格：{{ selectDara.B.data.bprice }}</p>
            </span>
          </div>

          <div v-if="selectDara.S">
            <span class="span-msg" v-if="selectDara.S.isSeller == false">
              <i class="el-icon-error">卖出失败</i>
              {{ selectDara.S.msg }}
            </span>
            <span class="span-data" v-if="selectDara.S.isSeller == true">
              <i class="el-icon-success">卖 出</i>
              <p v-for="item in selectDara.S.data" :key="item.id">
                {{ item }}
              </p>
            </span>
          </div>

          <el-table :data="selectDara.online"  size="mini">
            <el-table-column prop="id" label="id" width="50"></el-table-column>
            <el-table-column prop="num" label="数量" width="50"></el-table-column>
            <el-table-column prop="bdate" label="购买日期" width="80"> </el-table-column>
            <el-table-column prop="bprice" label="购买价格" width="60"> </el-table-column>
            <el-table-column prop="inday" label="持仓天数" width="60"> </el-table-column>
          </el-table>

          <div>
            <p v-if="selectDara.blance != undefined">
              余额：{{ selectDara.blance.toFixed(2) }}
            </p>
            <p>持股：{{ selectDara.assets }}</p>
            <p v-if="selectDara.summary != undefined">
              结余：{{ selectDara.summary.toFixed(2) }}
            </p>
          </div>
        </div>
        <div>{{}}</div>
      </el-col>
    </el-row>
  </div>
</template>
<script>
export default {
  props: {
    value: null,
    points:null
  },
  computed: {
    chartData: function () {
      return {
        columns: ["date", "open", "close", "low", "high", "vol"],
        rows: this.value,
      };
    },

    markPoint: function () {
      return {
        symbolSize: 20,
        label: {
          normal: {
            formatter: function (param) {
              return param != null ? param.value : "";
            },
          },
        },
        tooltip: {
          formatter: function (param) {
            return param.name + "<br>" + (param.data.coord || "");
          },
        },
        data:this.points

      };
    },
  },

  data() {
    var self = this;
    this.chartEvents = {
      click: function (e) {
        self.selectDara = self.chartData.rows[e.dataIndex];
        console.log(self.selectDara);
      },
    };
    this.tooltip = {
      trigger: "axis",
      position: function (point, params, dom, rect, size) {
        self.selectDara = self.chartData.rows[params[0].dataIndex];
        return;
      },
    };

    return {
      selectDara: {},
      chartSettings: {
        showMA: true,
        showVol: true,
        showDataZoom: true,
        downColor: "#00da3c",
        upColor: "#ec0000",
      },
      dataZoom: [
        {
          type: "slider",
          top: 0,
          height: 40,
          start: 0,
          end: 100,
        },
      ],
    };
  },
  methods: {
  
  },
};
</script>


<style>
.box {
  width: 100%;
  height: auto;
  /* background: red; */
}
.box1 {
  width: 100%;
  text-align: center;
  line-height: 100px;
  height: auto;
  font-size: 8px;
}
* {
  margin: 0;
  padding: 0;
}
.about {
  position: absolute;
  top: 100px;
  left: 0;
  width: 100%;
}
.span-msg {
  font-size: 12px;
  color: crimson;
}
.span-data {
  font-size: 12px;
  color: cornflowerblue;
}
</style>