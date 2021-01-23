<template>
  <div>
    <ve-candle 
      
      :data = "chartData"
      :events = "chartEvents"
      :settings = "chartSettings"
      :mark-point="markPoint"
      @ready-once="readyOnve"
      :data-zoom="dataZoom"
      :not-set-unchange="['dataZoom']"
    ></ve-candle>

  </div>
</template>
<script>
export default {
  props: {
    value: null,
  },
  computed: {
    chartData: function () {
      return {
        columns: ["date", "open", "close", "low", "high", "vol"],
        rows: this.value,
        selectedDepIndex: 1,
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
    function getbsPoint(val) {
      if(val.length<=0){
        return []
      }
      var list = []
      for (var item  in val) {
        var share = val[item]
        console.log(JSON.stringify(share))
        if (share.B != null) {
          list.push({
            name: "B",
            coord: [share.date, share.B],
            value: "B",
            itemStyle: {
              color: "rgb(255,150,200)",
              fontSize:"4"
              
            },
          });
        }
         if (share.S != null) {
          list.push({
            name: "S",
            coord: [share.date, share.S],
            value: "S",
            itemStyle: {
              color: "rgb(50,205,200)",
              fontSize:"4px"
            },
          });
        }
      }
      return list
    }
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
          top: 0,
          height: 40,
          start: 0,
          end: 100,
        },
      ],
      markPoint: {
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
        data: getbsPoint(this.value),
      },
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
</style>