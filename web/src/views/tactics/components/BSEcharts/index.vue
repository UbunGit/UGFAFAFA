<template>
  <div>
    <ve-candle
      :data="chartData"
      :events="chartEvents"
      height="300px"
      :settings="chartSettings"
      :mark-line="markLine"
      :mark-point="markPoint"
      @ready-once="readyOnve"
      :data-zoom="dataZoom"
    ></ve-candle>
    <div>{{ JSON.stringify(value) }}</div>
  </div>
</template>
<script>
export default {
  props: {
    value: [],
  },
  computed: {
    chartData: function () {
      return {
        columns: ["date", "open", "close", "low", "high", "volume"],
        rows: this.value,
        selectedDepIndex: 1,
      };
    },
    markPoint: {
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
        data:[{
            name: "B",
            coord: ["20200511", 4.6],
            value: 8.68,
            itemStyle: {
              color: "rgb(41,60,85)",
            },
          },
          {
            name: "S",
            coord: ["20200527", 3.68],
            value: 8.88,
            itemStyle: {
              color: "rgb(41,60,85)",
            },
          },
        ]
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
          start: 0,
          end: 100,
        },
      ],
      markLine: [
        {
          name: "平均线",
          type: "average",
        },
      ],
      
    };
  },
  methods: {
   test(e){
       alert(e)
   }
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
</style>