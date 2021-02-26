<template>
	<div>
		<view class="header">
			<label>初始：{{handle.defual.toFixed(3)}}</label></br>
			<label>持股：{{handle.have}}</label></br>
			<label>余额：{{handle.blance.toFixed(3)}}</label></br>
			<label>收益率：{{((handle.assets/(handle.defual*1.00)-1)*100).toFixed(3)}}%</label></br>
			<label >交易次数：{{handle.list.length}}</label></br>
			<label>资产：{{handle.assets.toFixed(3)}}</label></br>
			
		</view>

		<uni-ec-canvas class="uni-ec-canvas" id="candle1" canvas-id="multi-charts-pie" :ec="ec3"></uni-ec-canvas>

		<view class="footer">

			<div class="active">
				<button round type="info" class="settle" @click="handleEnd">结算</button>
				<button round type="info" class="buy" @click="handerBuy">{{handle.have>0?"持有":"买入"}}</button>
				<button round type="info" class="seller" @click="handerSeller">{{handle.have>0?"卖出":"观望"}}</button>
			</div>
		</view>
	</div>
</template>

<script>
	import uCharts from '@/components/u-charts/u-charts.js';
	import uniEcCanvas from "@/components/echarts/uni-ec-canvas";
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
				result: '',
				handle:{
					defual:10000, // 初始金额
					list:[], // 买卖记录
					blance:10000, // 余额
					have:0,// 持仓
					assets:10000, // 资产
				},
				ec3: {
					option: {
						animation: false,
						legend: {
							bottom: 10,
							left: 'center',
							data: ['Dow-Jones index', 'MA5', 'MA10', 'MA20', 'MA30']
						},
						tooltip: {
							trigger: 'axis',
							axisPointer: {
								type: 'cross'
							},
							borderWidth: 1,
							borderColor: '#ccc',
							padding: 10,
							textStyle: {
								color: '#000'
							},
							position: function(pos, params, el, elRect, size) {
								var obj = {
									top: 10
								};
								obj[['left', 'right'][+(pos[0] < size.viewSize[0] / 2)]] = 30;
								return obj;
							}
							// extraCssText: 'width: 170px'
						},
						axisPointer: {
							link: {
								xAxisIndex: 'all'
							},
							label: {
								backgroundColor: '#777'
							}
						},

						visualMap: {
							show: false,
							seriesIndex: 5,
							dimension: 2,
							pieces: [{
								value: 1,
								color: downColor
							}, {
								value: -1,
								color: upColor
							}]
						},
						grid: [{
								left: '10%',
								right: '8%',
								height: '40%'
							},
							{
								left: '10%',
								right: '8%',
								top: '63%',
								height: '16%'
							}
						],
						xAxis: [{
								type: 'category',
								data: data.categoryData,
								scale: true,
								boundaryGap: false,
								axisLine: {
									onZero: false
								},
								splitLine: {
									show: false
								},
								splitNumber: 20,
								min: 'dataMin',
								max: 'dataMax',
								axisPointer: {
									z: 100
								}
							},
							{
								type: 'category',
								gridIndex: 1,
								data: data.categoryData,
								scale: true,
								boundaryGap: false,
								axisLine: {
									onZero: false
								},
								axisTick: {
									show: false
								},
								splitLine: {
									show: false
								},
								axisLabel: {
									show: false
								},
								splitNumber: 20,
								min: 'dataMin',
								max: 'dataMax'
							}
						],
						yAxis: [{
								scale: true,
								splitArea: {
									show: true
								}
							},
							{
								scale: true,
								gridIndex: 1,
								splitNumber: 2,
								axisLabel: {
									show: false
								},
								axisLine: {
									show: false
								},
								axisTick: {
									show: false
								},
								splitLine: {
									show: false
								}
							}
						],
						dataZoom: [{
								type: 'inside',
								xAxisIndex: [0, 1],
								start: 0,
								end: 100
							},
							{
								show: true,
								xAxisIndex: [0, 1],
								type: 'slider',
								top: '0',
								start: 0,
								end: 100
							}
						],
						series: [{
								name: '日K',
								type: 'candlestick',
								data: [],
								itemStyle: {
									color: upColor,
									color0: downColor,
									borderColor: upBorderColor,
									borderColor0: downBorderColor
								},
								markPoint: {
									symbolSize: 20,
									itemStyle: {
										normal: {
											color: "#23232322",
											label: {
												show: true,
												color: "#232323", //气泡中字体颜色
												fontSize: 10
											}
										}
									},
									label: {
										normal: {
											formatter: function(param) {
												return param != null ? Math.round(param.value) : '';
											}
										}
									},
									tooltip: {
										formatter: function(param) {
											return param.name + '<br>' + (param.data.coord || '');
										}
									},
									data: [

										{
											name: 'highest value',
											type: 'max',
											valueDim: 'highest'
										},
										{
											name: 'lowest value',
											type: 'min',
											valueDim: 'lowest'
										},
										{
											name: 'average value on close',
											type: 'average',
											valueDim: 'close'
										}
									],

								},
								markLine: {
									symbol: ['none', 'none'],
									data: [

										{
											name: 'min line on close',
											type: 'min',
											valueDim: 'close'
										},
										{
											name: 'max line on close',
											type: 'max',
											valueDim: 'close'
										}
									]
								}
							},
							{
								name: 'MA5',
								type: 'line',
								data: calculateMA(5, data.values),
								smooth: true,
								lineStyle: {
									opacity: 0.5
								}
							},
							{
								name: 'MA10',
								type: 'line',
								data: calculateMA(10, data.values),
								smooth: true,
								lineStyle: {
									opacity: 0.5
								}
							},
							{
								name: 'MA20',
								type: 'line',
								data: calculateMA(20, data.values),
								smooth: true,
								lineStyle: {
									opacity: 0.5
								}
							},
							{
								name: 'MA30',
								type: 'line',
								data: calculateMA(30, data.values),
								smooth: true,
								lineStyle: {
									opacity: 0.5
								}
							},

							{
								name: 'Volume',
								type: 'bar',
								xAxisIndex: 1,
								yAxisIndex: 1,
								data: data.volumes
							},

						]
					}

				},
			};
		},
		onReady() {
			setTimeout(() => {
				// this.ec3.option.series[0].data = data.values
				console.log("折线图数据改变啦");
			}, 1000);

		},
		components: {
			uniEcCanvas
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
						console.log(res.data.data)
						_self.result = JSON.parse(res.data.data)
						let tdata = _self.updateCanvaCandle()
					},
					fail: () => {
						_self.tips = "网络错误，小程序端请检查合法域名";
					},
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
				if(_self.handle.have==0){
					let data = _self.result[_self.itemCount]
					
					_self.ec3.option.series[0].markPoint.data.push({
						name: 'XX标点',
						coord: [data.date, data.open],
						value: "B",
						itemStyle: {
							color: "rgb(50,205,200)",
							fontSize: "4px",
						}
					})
					_self.handle.list.push(
					{"type":"B",
					"date":data.date
					})
					let count = Math.floor(_self.handle.blance/(data.close*100))*100
					_self.handle.blance = _self.handle.blance-(count*data.close)
					_self.handle.have = count
				}
				if(_self.itemCount<60){
					_self.itemCount = _self.itemCount + 1
					_self.updateCanvaCandle()
				}
				let data = _self.result[_self.itemCount]
				_self.handle.assets = _self.handle.blance+_self.handle.have*data.close
				
				

			},
			handerSeller(){
				if(_self.handle.have>0){
					let data = _self.result[_self.itemCount]
					
					_self.ec3.option.series[0].markPoint.data.push({
						name: 'XX标点',
						coord: [data.date, data.open],
						value: "S",
						itemStyle: {
							color: "red",
							fontSize: "red",
						}
					})
					
					let count = _self.handle.have
					_self.handle.blance = _self.handle.blance+(count*data.close)
					_self.handle.have = 0
				}
				
				if(_self.itemCount<60){
					_self.itemCount = _self.itemCount + 1
					_self.updateCanvaCandle()
				}
				let data = _self.result[_self.itemCount]
				_self.handle.assets = _self.handle.blance+_self.handle.have*data.close
			},
			handleEnd(){
				uni.showModal({
				    title: '提示',
				    content: '这是一个模态弹窗',
				    success: function (res) {
				        if (res.confirm) {
				            console.log('用户点击确定');
				        } else if (res.cancel) {
				            console.log('用户点击取消');
				        }
				    }
				});
			},
			updateCanvaCandle() {
				var series = []
				for (var i = 0; i < Math.min(_self.itemCount, _self.result.length); i++) {
					let data = _self.result[i]
					// 数据意义：开盘(open)，收盘(close)，最低(lowest)，最高(highest)
					series.push([data.date, data.open, data.close, data.low, data.high, data.high])

				}
				data = splitData(series)

				_self.ec3.option.series[0].data = data.values
				_self.ec3.option.series[1].data = calculateMA(30, data)
				_self.ec3.option.series[2].data = calculateMA(5, data)
				_self.ec3.option.series[3].data = calculateMA(10, data)
				_self.ec3.option.series[4].data = calculateMA(20, data)
				_self.ec3.option.series[5].data = data.volumes
				_self.ec3.option.xAxis[0].data = data.categoryData
				_self.ec3.option.xAxis[1].data = data.categoryData
			}
		},
	};

	var upColor = '#ec0000';
	var upBorderColor = '#8A0000';
	var downColor = '#00da3c';
	var downBorderColor = '#008F28';

	var data = splitData([

	]);

	function splitData(rawData) {
		var categoryData = [];
		var values = [];
		var volumes = [];
		for (var i = 0; i < rawData.length; i++) {
			categoryData.push(rawData[i].splice(0, 1)[0]);
			values.push(rawData[i]);
			volumes.push([i, rawData[i][4], rawData[i][0] > rawData[i][1] ? 1 : -1]);
		}

		return {
			categoryData: categoryData,
			values: values,
			volumes: volumes
		};
	}

	function calculateMA(dayCount, data) {
		var result = [];
		for (var i = 0, len = data.values.length; i < len; i++) {
			if (i < dayCount) {
				result.push('-');
				continue;
			}
			var sum = 0;
			for (var j = 0; j < dayCount; j++) {
				sum += data.values[i - j][1];
			}
			result.push(+(sum / dayCount).toFixed(3));
		}
		return result;
	}
</script>

<style>
	.uni-ec-canvas {
		width: 750upx;
		height: 750upx;
		display: block;
	}

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
		height: 700upx;
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
		height: 60px;

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
