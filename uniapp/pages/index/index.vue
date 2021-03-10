<template>
	<div>
		<view class="header">


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
									top: 110
								};

								obj[['left', 'right'][+(pos[0] < size.viewSize[0] / 2)]] = 30;
								console.log(obj)
								return obj;
							},
							extraCssText: 'width: 170px'
						},
						axisPointer: {
							link: {
								xAxisIndex: 'all'
							},
							label: {
								backgroundColor: '#1e2677'
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
								top: "20upx",
								height: '160upx'
							},
							{
								left: '10%',
								right: '8%',
								top: '200upx',
								height: '16%'
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
								height: "15upx",
							},
							{
								show: true,
								xAxisIndex: [0, 1],
								type: 'slider',
								top: '0',
								height: "15upx",
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
							{
								name: 'MA10',
								type: 'line',
								data: this.calculateMA(10, this.sresult),
								symbol: 'none',
								lineStyle: {
									opacity: 0.5
								}
							},
							{
								name: 'MA20',
								type: 'line',
								data: this.calculateMA(20, this.sresult),
								symbol: 'none',
								lineStyle: {
									opacity: 0.5
								}
							},
							{
								name: 'MA30',
								type: 'line',
								data: this.calculateMA(30, this.sresult),
								symbol: 'none',
								lineStyle: {
									opacity: 0.5
								}
							},

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
				return
				_self.reload()
				uni.request({
					url: 'http://api.tushare.pro',
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
						// _self.result = JSON.parse(res.data.data)
						
					},
					fail: () => {
						_self.tips = "网络错误，小程序端请检查合法域名";
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


			},

			handerBuy() {
				if (_self.handle.have == 0) {
					let data = _self.result[_self.itemCount + _self.offset]
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
				}
				if (_self.offset < 30) {
					_self.offset = _self.offset + 1
					_self.updateCanvaCandle()
				}
				let data = _self.result[_self.itemCount + _self.offset]
				_self.handle.assets = _self.handle.blance + _self.handle.have * data.close



			},

			handerSeller() {
				if (_self.handle.have > 0) {
					let data = _self.result[_self.itemCount + _self.offset]

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
				let data = _self.result[_self.itemCount + _self.offset]
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
			
				_self.sresult = splitData(series)
				

			},
			// 获取股票阶段收益
			getStoreIncome() {
				var begindata = _self.result[_self.itemCount]
				var enddata = _self.result[_self.itemCount + _self.offset]
				return ((enddata.close / begindata.close) - 1) * 100

			},
			getHandleIncome() {
				var end = (_self.handle.assets / (_self.handle.defual) - 1) * 100
				return end
			},
			calculateMA(dayCount, data) {
				var result = [];

				for (var i = 0, len = data.values.length; i < len; i++) {
					var resindex = _self.itemCount + i - 30
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

	// var data = splitData([]);

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
