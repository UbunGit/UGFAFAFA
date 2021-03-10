<template>
	<div>
		<view class="header">
			<label>初始：{{handle.defual.toFixed(3)}}</label></br>
			<label>持股：{{handle.have}}</label></br>
			<label>余额：{{handle.blance.toFixed(3)}}</label></br>

			<label>交易次数：{{handle.list.length}}</label></br>
			<label>资产：{{handle.assets.toFixed(3)}}</label></br>
			<label>股票收益：{{getStoreIncome().toFixed(2)}}%</label></br>
			<label>收益率：{{getHandleIncome().toFixed(3)}}%</label></br>
		
		</view>

		<uni-ec-canvas class="uni-ec-canvas" id="candle1" canvas-id="multi-charts-pie" :ec="chartdata"></uni-ec-canvas>

		<view class="footer">

			<div class="active">
				<button round type="info" class="settle" @click="handleEnd">结算{{offset}}</button>
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
		computed: {
			chartdata() {
				return {
					option: {
						animation: false,
						legend: {
							top: 200,
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
								left: '8%',
								right: '8%',
								top:"20",
								height: '160'
							},
							{
								left: '8%',
								right: '8%',
								top: '200',
								height: '60'
							}
						],
						xAxis: [{
								type: 'category',
								data: this.sresult.categoryData,
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
								data: this.sresult.categoryData,
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
								end: 100,
								height:"15upx",
							},
							{
								show: true,
								xAxisIndex: [0, 1],
								type: 'slider',
								top: '0',
								height:"15upx",
								start: 0,
								end: 100
							}
						],
						series: [{
								name: '日K',
								type: 'candlestick',
								data: this.sresult.values,
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
									data: this.pointData,

								},
								markLine: {
									symbol: ['none', 'none'],
									data: [

										{
											name: 'min line on lowest',
											type: 'min',
											valueDim: 'lowest'
										},
										{
											name: 'max line on highest',
											type: 'max',
											valueDim: 'highest'
										}
									]
								}
							},
							{
								name: 'MA5',
								type: 'line',
								data: this.calculateMA(5, this.sresult),
								symbol: 'none',
								lineStyle: {
									opacity: 0.5
								}
							},
							// {
							// 	name: 'MA10',
							// 	type: 'line',
							// 	data: this.calculateMA(10, this.sresult),
							// 	symbol: 'none',
							// 	lineStyle: {
							// 		opacity: 0.5
							// 	}
							// },
							// {
							// 	name: 'MA20',
							// 	type: 'line',
							// 	data: this.calculateMA(20, this.sresult),
							// 	symbol: 'none',
							// 	lineStyle: {
							// 		opacity: 0.5
							// 	}
							// },
							// {
							// 	name: 'MA30',
							// 	type: 'line',
							// 	data: this.calculateMA(30, this.sresult),
							// 	symbol: 'none',
							// 	lineStyle: {
							// 		opacity: 0.5
							// 	}
							// },

							{
								name: 'Volume',
								type: 'bar',
								xAxisIndex: 1,
								yAxisIndex: 1,
								data: this.sresult.volumes
							},

						]
					}

				}
			}
		},

		data() {
			return {
				cWidth: '',
				cHeight: '',
				pixelRatio: 1,
				itemCount: 30, //x轴单屏数据密度
				offset: 0,
				result: [],
				sresult: {
					categoryData: [],
					values: [],
					volumes: [],
				},
				pointData: [
				
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
				handle: {
					defual: 10000, // 初始金额
					list: [], // 买卖记录
					blance: 10000, // 余额
					have: 0, // 持仓
					assets: 10000, // 资产
				},
			};
		},
		onReady() {

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
				_self.reload()
				uni.request({
					url: 'https://api.tushare.pro',
					method: "POST",
					data: {
						"api_name":"daily",
						"token":"8631d6ca5dccdcd4b9e0eed7286611e40507c7eba04649c0eee71195",
						"params":{"ts_code":"300022.SZ"},
						"fields":""
					},
					success: function(res) {
				
						let result = res.data.data
						let datas = result.items.reverse()
						console.log(datas)
						var dataArr = []
						for (var i = 0; i < datas.length; i++) {
							let values = datas[i]
							let keys =  result.fields
							var data = {}
							for (var j = 0; j < keys.length; j++) {
								let key = keys[j]
								data[key]= values[j]
							}
							dataArr.push(data)
						}
				
						_self.result = dataArr
				
						console.log(_self.result)
						if (_self.result.length < 60) {
							uni.showModal({
								title: '错误',
								content: '数据量太少',
								success: function(res) {
									if (res.confirm) {

										_self.getServerData()
									} else if (res.cancel) {
										_self.getServerData()
									}
								}
							});
							return;
						}
						var max = _self.result.length - 30
						var min = 30
						_self.itemCount = Math.round(Math.random() * (max - min)) + min
						console.log(_self.itemCount)
						let tdata = _self.updateCanvaCandle()
						uni.showToast({
						    title: '数据获取成功',
						    duration: 2000
						});
					},
					fail: (error) => {
						uni.showToast({
						    title: JSON.stringify(error),
						    duration: 2000
						});
					},
				});
			},
			
			reload() {
				_self.offset = 0
				_self.handle = {
					defual: 10000, // 初始金额
					list: [], // 买卖记录
					blance: 10000, // 余额
					have: 0, // 持仓
					assets: 10000, // 资产
				}
				_self.pointData = [{
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
					}]
				

			},

			handerBuy() {
				if (_self.handle.have == 0) {
					let data = _self.result[_self.itemCount + _self.offset-1]
					_self.pointData.push({
						name: 'XX标点',
						coord: [data.trade_date, data.open],
						value: "B",
						itemStyle: {
							color: "rgb(50,205,200)",
							fontSize: "4px",
						}
					})
					_self.handle.list.push({
						"type": "B",
						"date": data.trade_date
					})
					let count = Math.floor(_self.handle.blance / (data.close * 100)) * 100
					_self.handle.blance = _self.handle.blance - (count * data.close)
					_self.handle.have = count
					console.log("B"+data.trade_date +" "+ data.close+" "+count)
					
				}
				if (_self.offset < 30) {
					_self.offset = _self.offset + 1
					_self.updateCanvaCandle()
				}
				let data = _self.result[_self.itemCount + _self.offset-1]
				console.log("new"+data.trade_date +" "+ data.close)

			},

			handerSeller() {
				if (_self.handle.have > 0) {
					let data = _self.result[_self.itemCount + _self.offset-1]

					_self.pointData.push({
						name: 'XX标点',
						coord: [data.trade_date, data.open],
						value: "S",
						itemStyle: {
							color: "red",
							fontSize: "red",
						}
					})

					let count = _self.handle.have
					_self.handle.blance = _self.handle.blance + (count * data.close)
					_self.handle.have = 0
				}

				if (_self.offset < 30) {
					_self.offset = _self.offset + 1
					_self.updateCanvaCandle()
				}
				let data = _self.result[_self.itemCount + _self.offset-1]
				_self.handle.assets = _self.handle.blance + _self.handle.have * data.close
			},

			handleEnd() {
				uni.showModal({
					title: '提示',
					content: '这是一个模态弹窗',
					success: function(res) {
						if (res.confirm) {
							console.log('用户点击确定');
							_self.getServerData()
						} else if (res.cancel) {
							console.log('用户点击取消');
						}
					}
				});
			},

			updateCanvaCandle() {

				var series = []
				var begin = _self.itemCount - 30
				var end = _self.itemCount + _self.offset
				for (var i = begin; i < Math.min(end, _self.result.length); i++) {
					let data = _self.result[i]
					// 数据意义：开盘(open)，收盘(close)，最低(lowest)，最高(highest)
					series.push([data.trade_date, data.open, data.close, data.low, data.high, data.high])
				}
				
				_self.sresult = _self.splitData(series)
			},
			splitData(rawData) {
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
			},
			// 获取股票阶段收益
			getStoreIncome() {
				if(_self.result != undefined){
					var begindata = _self.result[_self.itemCount]
					var enddata = _self.result[_self.itemCount + _self.offset-1]
					return ((enddata.close / begindata.close) - 1) * 100
				}else{
					return 0
				}
				
			
			},
			getHandleIncome() {
				var end = (_self.handle.assets / (_self.handle.defual) - 1) * 100
				return end
			},
			calculateMA(dayCount, data) {
				console.log("1111")
				var result = [];
				
				for (var i = 0, len = data.values.length; i < len; i++) {
					let item = data[i]
					let key = "ma"+dayCount.toString()
					
					var resindex = _self.itemCount+i-30
					if (resindex < dayCount) {
						result.push('-');
						continue;
					}
					var sum = 0;
					for (var j = 0; j < dayCount; j++) {
						sum += _self.result[resindex - j].close;
					}
					result.push(+(sum / dayCount).toFixed(3));
				}
			
				return result;

			}

		},
	};

	var upColor = '#ec0000';
	var upBorderColor = '#8A0000';
	var downColor = '#00da3c';
	var downBorderColor = '#008F28';

</script>

<style>
	.uni-ec-canvas {
		width: 750upx;
		height: 700upx;
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
