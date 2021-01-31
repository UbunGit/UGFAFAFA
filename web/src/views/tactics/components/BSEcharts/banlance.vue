<template>
  <div>
    <ve-bar height="180px"
     :data="chartData" 
     :settings="chartSettings"
     :judge-width="true"
     ></ve-bar>
  </div>
</template>

<script>
export default {
  props: {
    value: null,

  },
  computed: {
      chartData: function () {
       return{
        columns: ["日期", "初始金额", "余额", "股票资产"],
        rows: [{ 日期: this.value.date, 初始金额: this.value.money, 余额: this.value.blance, 股票资产: this.value.assets*this.value.close }],
       } 
      },
  },
  data() {
    this.chartSettings = {
      stack: {
        xxx: ["余额", "股票资产"],
      },

    };
    return {
      
    };
  },
};
</script>