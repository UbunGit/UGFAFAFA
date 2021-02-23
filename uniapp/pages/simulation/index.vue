<template>
	<div>
		<div class="header">
			<label>收益：10000.00</label></br>
			<label>收益率：0.00%</label>
			<label>收益：10000.00</label></br>
			<label>收益率：0.00%</label>
			<label>收益：10000.00</label></br>
			<label>收益率：0.00%</label>
		</div>



			<view class="qiun-charts">
				<!--#ifdef MP-ALIPAY -->
				<canvas canvas-id="canvasCandle" id="canvasCandle" class="charts" :width="cWidth*pixelRatio" :height="cHeight*pixelRatio"
				 :style="{'width':cWidth+'px','height':cHeight+'px'}" disable-scroll=true @touchstart="touchCandle" @touchmove="moveCandle"
				 @touchend="touchEndCandle"></canvas>
				<!--#endif-->
				<!--#ifndef MP-ALIPAY -->
				<canvas canvas-id="canvasCandle" id="canvasCandle" class="charts" disable-scroll=true @touchstart="touchCandle"
				 @touchmove="moveCandle" @touchend="touchEndCandle"></canvas>
				<!--#endif-->
			</view>




		<view class="footer">

			<div class="active">
				<button round type="info" class="settle">结算</button>
				<button round type="info" class="buy" @click="handerBuy">买入</button>
				<button round type="info" class="seller">卖出</button>
			</div>
		</view>
	</div>
</template>

<script>
	import uCharts from '@/components/u-charts/u-charts.js';
	import {
		isJSON
	} from '@/utils/checker.js';
	var _self;
	var canvaCandle = null;
	export default {
		data() {
			return {
				cWidth: '',
				cHeight: '',
				pixelRatio: 1,
				itemCount: 30, //x轴单屏数据密度
				result: ''
			}
		},
		onLoad() {
			_self = this;
			//#ifdef MP-ALIPAY
			uni.getSystemInfo({
				success: function(res) {
					if (res.pixelRatio > 1) {

						_self.pixelRatio = res.pixelRatio;

					}
				}
			});
			//#endif
			this.cWidth = uni.upx2px(750);
			this.cHeight = uni.upx2px(500);
			this.getServerData();
		},
		methods: {
			getServerData() {
				uni.request({
					url: this.baseUrl + '/share/simulation',
					data: {
						"code": "300022.sz"
					},
					success: function(res) {

						_self.result = JSON.parse(res.data.data)

						let Candle = {
							categories: [],
							series: []
						};
						var series = []
						var categories = []
						for (var i = 0; i < Math.min(_self.itemCount, _self.result.length); i++) {
							let data = _self.result[i]

							categories.push(data.date)
							series.push([data.open, data.close, data.low, data.high])

						}
						Candle.series = [{
							"name": "测试",
							"data": series
						}]
						Candle.categories = categories
						console.log(Candle)
						_self.showCandle("canvasCandle", Candle);
						// _self.updateCanvaCandle()
					},
					fail: () => {
						_self.tips = "网络错误，小程序端请检查合法域名";
					},
				});
			},
			showCandle(canvasId, chartData) {
				canvaCandle = new uCharts({
					$this: _self,
					canvasId: canvasId,
					type: 'candlestick',
					fontSize: 11,
					padding: [15, 15, 0, 15],
					legend: {
						show: true,
						padding: 5,
						lineHeight: 11,
						margin: 8,
					},
					background: '#FFFFFF',
					pixelRatio: _self.pixelRatio,
					enableMarkLine: true,
					/***需要开启标记线***/
					categories: chartData.categories,
					series: chartData.series,
					animation: false,
					enableScroll: true, //开启图表拖拽功能
					xAxis: {
						disableGrid: true, //不绘制X轴网格线
						labelCount: 5, //X轴文案数量
						type: 'grid',
						gridType: 'dash',
						itemCount: Math.min((_self.itemCount + 1), 30), //可不填写，配合enableScroll图表拖拽功能使用，x轴单屏显示数据的数量，默认为5个
						scrollShow: true, //新增是否显示滚动条，默认false
						scrollAlign: 'right',
						scrollBackgroundColor: '#F7F7FF', //可不填写，配合enableScroll图表拖拽功能使用，X轴滚动条背景颜色,默认为 #EFEBEF
						scrollColor: '#A6A6A6', //可不填写，配合enableScroll图表拖拽功能使用，X轴滚动条颜色,默认为 #A6A6A6
					},
					yAxis: {
						disabled: true,
						gridType: 'dash',
						splitNumber: 5,
						format: (val) => {
							return val
						}
					},
					width: _self.cWidth * _self.pixelRatio,
					height: _self.cHeight * _self.pixelRatio,
					dataLabel: false,
					dataPointShape: true,
					extra: {
						candle: {
							color: {
								upLine: '#f04864',
								upFill: '#f04864',
								downLine: '#2fc25b',
								downFill: '#2fc25b'
							},
							average: {
								show: true,
								name: ['MA5', 'MA10', 'MA30'],
								day: [5, 10, 20],
								color: ['#1890ff', '#2fc25b', '#facc14']
							}
						},
						tooltip: {
							bgColor: '#000000',
							bgOpacity: 0.7,
							gridType: 'dash',
							dashLength: 5,
							gridColor: '#1890ff',
							fontColor: '#FFFFFF',
							horizentalLine: true,
							xAxisLabel: true,
							yAxisLabel: true,
							labelBgColor: '#DFE8FF',
							labelBgOpacity: 0.95,
							labelAlign: 'left',
							labelFontColor: '#666666'
						},
						markLine: {
							type: 'dash',
							dashLength: 5,
							data: [{
								value: 2150,
								lineColor: '#f04864',
								showLabel: true
							}, {
								value: 2350,
								lineColor: '#f04864',
								showLabel: true
							}]
						}
					}
				});
			},
			touchCandle(e) {
				canvaCandle.scrollStart(e);
			},
			moveCandle(e) {
				canvaCandle.scroll(e);
			},
			touchEndCandle(e) {
				canvaCandle.scrollEnd(e);
				//下面是toolTip事件，如果滚动后不需要显示，可不填写
				canvaCandle.showToolTip(e, {
					format: function(item, category) {
						return category + ' ' + item.name + ':' + item.data
					}
				});
				//这里演示了获取点击序列的方法，如需要将数据显示到canvas外面，可用此方法。
				var xx = canvaCandle.getCurrentDataIndex(e);
				//console.log(canvaCandle.opts.series[0].data[xx]);
				//下面是计算好的MA均线集合，想要点击序列中的当前数据，需要自己遍历seriesMA
				//console.log(canvaCandle.opts.seriesMA);
			},
			tapButton(type) {

			},
			sliderMove(e) {
				_self.itemCount = e.detail.value;
				_self.zoomCandle(e.detail.value);
			},
			zoomCandle(val) {
				canvaCandle.zoom({
					itemCount: val
				});
			},
			changeData() {

			},
			handerBuy() {
				_self.itemCount = _self.itemCount + 1
				_self.updateCanvaCandle()

			},
			updateCanvaCandle() {
				var series = []
				var categories = []
				for (var i = 0; i < Math.min(_self.itemCount, _self.result.length); i++) {
					let data = _self.result[i]
					console.log(data)
					categories.push(data.date)
					series.push([data.open, data.close, data.low, data.high])

				}
				canvaCandle.updateData({
					series: [{
						"name": "测试",
						"data": series
					}],
					categories: categories,
					xAxis: {
						itemCount: _self.itemCount,
					}, //可不填写，配合enableScroll图表拖拽功能使用，x轴单屏显示数据的数量，默认为5个
					scrollPosition: "right"
				});

			}
		}


	}
</script>

<style>
	.qiun-padding {
		padding: 2%;
		width: 96%;
	}

	.qiun-wrap {
		display: flex;
		flex-wrap: wrap;
	}

	.qiun-rows {
		display: flex;
		flex-direction: row !important;
	}

	.qiun-columns {
		display: flex;
		flex-direction: column !important;
	}

	.qiun-common-mt {
		margin-top: 10upx;
	}

	.qiun-bg-white {
		background: #FFFFFF;
	}

	.qiun-title-bar {
		width: 96%;
		padding: 10upx 2%;
		flex-wrap: nowrap;
	}

	.qiun-title-dot-light {
		border-left: 10upx solid #0ea391;
		padding-left: 10upx;
		font-size: 32upx;
		color: #000000
	}

	/* 通用样式 */
	.qiun-charts {
		width: 750upx;
		height: 500upx;
		background-color: #FFFFFF;
	}

	.charts {

		width: 100%;
		height: 500upx;
		background-color: #FFFFF0;
	}

	.header {
		display: flex;
		flex-wrap: wrap;

	}

	.header label {
		display: flex;
		flex-wrap: wrap;
		left: 12px;
		font-size: 12px;
		color: #333333;
		margin: 15upx;
	}

	.footer {
		position: fixed;
		bottom: 0px;
		background-color: #EEEEEE;
		width: 100%;
		flex-direction: row;
		justify-content: space-between;
		height: 80px;

	}

	.footer button {
		position: absolute;
		display: inline-block;
		font-size: 10px;

		width: 60px;
		height: 30px;
		bottom: 4px;
		color: #FFFFFF;
	}

	.settle {
		border: 1px solid crimson;
		background-color: crimson;
		left: 50%;
		transform: translateX(-50%);
	}

	.buy {

		border: 1px solid crimson;
		background-color: crimson;
		left: 15px;
	}

	.seller {

		border: 1px solid rgb(101, 59, 201);
		background-color: rgb(101, 59, 201);
		right: 15px;
	}

	.active {}
</style>
