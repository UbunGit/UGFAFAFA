  <template>
  <div>
    <div style="wigth=100%">
      <ve-candle :data="chartData" :settings="chartSettings">
      </ve-candle>
    </div>
    <div style="wigth=100%, height=120px">
      <ve-line :data="amountdata" :settings="amountSettings" height="180pt"></ve-line>
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
      },
      chartData: {
        columns: ["date", "open", "close", "low", "high", "volume"],
        rows: [
            { 'date': '2004-01-05', open: 10411.85, close: 10544.07, low: 10411.85, high: 10575.92, volume: 221290000 },
            { 'date': '2004-01-06', open: 10543.85, close: 10538.66, low: 10454.37, high: 10584.07, volume: 191460000 },
            { 'date': '2004-01-07', open: 10535.46, close: 10529.03, low: 10432.12, high: 10587.55, volume: 225490000 },
            { 'date': '2004-01-08', open: 10530.07, close: 10592.44, low: 10480.59, high: 10651.99, volume: 237770000 },
            { 'date': '2004-01-09', open: 10589.25, close: 10458.89, low: 10420.52, high: 10603.48, volume: 223250000 },
          ]
      },
      amountdata: {
          columns: ['date', 'amounts','store','sumAmount'],
          rows: [],
          
      },
      amountSettings: {
        showDataZoom: true,
        scale:[true,true],
        labelMap: {
            "sumAmount":"总资产",
            "amounts":"余额",
            "store":"持股数"
          },
      
      },
      
    };
  }
};
</script>
<style>

</style>