<template>
  <div>

        <ve-candle
          :data="chartData"
          :events="chartEvents"
          :settings="chartSettings"
          :mark-point="markPoint"
          :data-zoom="dataZoom"
          :not-set-unchange="['dataZoom']"
          :tooltip="tooltip"
        >
        </ve-candle>

        <ve-line
          :data="amountData"
          :settings="amountSettings"
          :data-zoom="dataZoom"
          :events="chartEvents"
          :tooltip="tooltip"
          height="300px"
        ></ve-line>

  </div>
</template>
<script>
export default {
  props: {
    value: null,
    points: null,
  },
  computed: {
    chartData: function () {
      return {
        columns: ["date", "open", "close", "low", "high", "vol"],
        rows: this.value,
      };
    },
    amountData: function () {
      return {
        scale:[true, false],
        columns: ["date", "blance", "summary"],
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
        data: this.points,
      };
    },
  },

  data() {
    var self = this;
    this.chartEvents = {
      click: function (e) {
        var selectdata = self.chartData.rows[e.dataIndex]
        self.selectDara = selectdata;
        console.log(self.selectDara);
      },
      mouseup: function (e) {
       
      }
    };
    this.tooltip = {
      trigger: "axis",
      position: function (point, params, dom, rect, size) {
        var selectdata = self.chartData.rows[params[0].dataIndex]
        self.selectDara = selectdata;
        self.emit_do(selectdata)
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
      amountSettings: {
        labelMap: {
          summary: "总资产",
          blance: "余额",
        },
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
    emit_do(val){
      this.$emit("select", val);
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
.span-msg {
  font-size: 12px;
  color: crimson;
}
.span-data {
  font-size: 12px;
  color: cornflowerblue;
}
</style>