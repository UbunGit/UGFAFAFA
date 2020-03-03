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
        metrics:["date", "open", "close", "low", "high", "volume", "amount"]
      },
      chartData: {
        columns: ["date", "open", "close", "low", "high", "volume", "amount"],
        rows: []
      },
      amountdata: {
          columns: ['date', 'amounts','store','sumAmount'],
          rows: []
      },
      amountSettings: {
        showDataZoom: true,
        scale:[true,true]
      },
      
    };
  }
};
</script>
<style>

</style>