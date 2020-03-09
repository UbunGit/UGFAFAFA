<template>
<div>测试
   <ve-line
      :x-axis="xAxis"
      :y-axis="yAxis"
      :extend="extend"
      :not-set-unchange="['dataZoom']"
      :legend="legend"
      :height="chartHeight + 'px'">
      <div
        v-if="isEmpty"
        class="data-empty">{{ emptyTips|l }}
    </div>
    </ve-line>
</div>
</template>

<script>
export default {
        extend: {
        series: [],
        grid: [],
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'cross'
          },
          formatter: function(params) {
            var tip = '时间：' + params[0].value[0]
            params.forEach(param => {
              tip += '<br/>' + param.marker + param.seriesName + '：' + Number(param.value[1]).toFixed(4)
            })
            return tip
          }
        },
        axisPointer: {
          link: { xAxisIndex: 'all' },
          label: {
            backgroundColor: '#777'
          }
        },
        toolbox: {
          right: 0,
          feature: {
            dataZoom: {
              yAxisIndex: false
            }
          }
        }
      },

///以下为 曲线初始化
    initChartOptions() {
      const whiteHeight = this.whiteHeight
      const singleHeight = this.singleHeight
      let seriesOptions = []
      let gridOptions = []
      let legendOptions = []
      let xAxisOptions = []
      let yAxisOptions = []

      this.dataset.forEach((fields, gridIndex) => {
        let startYAxisIndex = yAxisOptions.length
        let yAxisNames = []
        fields.forEach(field => {
          // yAxis name
          if (!yAxisNames.includes(field.axisName)) {
            yAxisNames.push(field.axisName)
          }
        })

        let legendItemData = []
        fields.forEach(field => {
          // series
          seriesOptions.push({
            key: field.key,
            name: field.name,
            type: field.type || 'line',
            gridIndex: gridIndex,
            xAxisIndex: gridIndex,
            yAxisIndex: startYAxisIndex + yAxisNames.indexOf(field.axisName),
            data: [],
            showSymbol: false,
            hoverAnimation: false,
            smooth: false, // 不平滑曲线
            // smoothMonotone: 'x' // 如果要平滑，请启用此属性，避免出现时间的不单调性
            markPoint: field.markPoint || {} // 最大值最小值的配置
          })
          // legend
          legendItemData.push(field.name)
        })
        let legendItem = {
          data: legendItemData,
          top: gridIndex * (singleHeight + whiteHeight)
        }
        legendOptions.push(legendItem)

        // grid
        gridOptions.push({
          left: 60,
          right: 60,
          top: gridIndex * (singleHeight + whiteHeight) + whiteHeight,
          height: singleHeight - whiteHeight,
          containLabel: false
        })
        // xAxis
        xAxisOptions.push({
          type: 'time',
          gridIndex: gridIndex,
          axisLine: {
            show: true,
            lineStyle: {
              color: '#999'
            }
          },
          splitLine: {
            show: true
          }
        })
        // yAxis
        yAxisNames.forEach(axisName => {
          yAxisOptions.push({
            type: 'value',
            name: axisName,
            scale: true, // 是否是脱离 0 值比例。设置成 true 后坐标刻度不会强制包含零刻度。
            gridIndex: gridIndex,
            axisLine: {
              show: true,
              lineStyle: {
                color: '#999'
              }
            },
            splitLine: {
              show: false
            }
          })
        })
      })

      this.extend.series = seriesOptions
      this.extend.grid = gridOptions
      this.legend = legendOptions
      this.xAxis = xAxisOptions
      this.yAxis = yAxisOptions
      // chart height
      this.chartHeight = (singleHeight + whiteHeight) * this.dataset.length
    }

};
</script>