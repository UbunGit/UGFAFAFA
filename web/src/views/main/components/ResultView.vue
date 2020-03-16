  <template>
  <div>
    <div style="wigth=100%">
      <ve-candle :data="chartData" :settings="chartSettings" @ready-once="readyOnve"></ve-candle>
      <ve-histogram
        :data="histogramdata"
        :settings="histogramSettings"
        @ready-once="readyOnve"
        height="160pt"
      ></ve-histogram>
    </div>
    <div style="wigth=100%, height=160px">
      <ve-line
        :data="amountdata"
        :settings="amountSettings"
        @ready-once="readyOnve"
        height="160pt"
      ></ve-line>
    </div>
  </div>
</template>

  <script>
export default {
  created: function() {},
  props: {
    value: Array
  },
  watch: {
    value: {
      handler(newValue, oldValue) {
        if (newValue != null) {
          this.chartData.rows = newValue;
          this.amountdata.rows = newValue;
          this.histogramdata.rows = newValue;
        }
      },
      immediate: true
    }
  },

  data() {
    return {
      chartSettings: {
        showMA: true,
        showVol: true,
        downColor: "#00da3c",
        upColor: "#ec0000"
      },
      chartData: {
        columns: ["date", "open", "close", "low", "high", "volume"],
        rows: [],
        selectedDepIndex: 1
      },
      amountdata: {
        columns: ["date", "store", "sumAmount"],
        rows: [],
        showDataZoom: true
      },
      amountSettings: {
    
        // scale: [true, true],
        smooth: false,
        axisSite: { right: ["store"] },
        yAxisName: ['总资产', '持股数'],
        labelMap: {
          sumAmount: "总资产",
          store: "持股数"
        }
      },
      histogramdata: {
          columns: ['date', 'MACD','DIFF','DEA','k','d','j'],
          rows: [],
          
      },
      histogramSettings: {
        showDataZoom: true,
        scale:[true,true],
        smooth: false,
        showLine: ['DIFF','DEA','k','d','j'],
        axisSite: { right: ['k','d','j'] },
        yAxisType: ['KMB', 'KMB'],
        yAxisName: ['数值', '比率']
      },
    };
  },
  methods: {
    readyOnve(echart, options, echartsLib) {
      echart.group = "group1";
      echartsLib.connect("group1");
    }
  }
};
</script>
<style>
</style>