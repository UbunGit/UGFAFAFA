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
	
			<view class="qiun-columns">
					
					<view class="qiun-charts">
						<!--#ifdef MP-ALIPAY -->
						<canvas canvas-id="canvasCandle" id="canvasCandle" class="charts" :width="cWidth*pixelRatio" :height="cHeight*pixelRatio" :style="{'width':cWidth+'px','height':cHeight+'px'}" disable-scroll=true @touchstart="touchCandle" @touchmove="moveCandle" @touchend="touchEndCandle"></canvas>
						<!--#endif-->
						<!--#ifndef MP-ALIPAY -->
						<canvas canvas-id="canvasCandle" id="canvasCandle" class="charts" disable-scroll=true @touchstart="touchCandle" @touchmove="moveCandle" @touchend="touchEndCandle"></canvas>
						<!--#endif-->
					</view>
					<view class="qiun-padding qiun-bg-white ">
						<slider :value="itemCount" min="5" :max="sliderMax" block-color="#f8f8f8" block-size="18" @changing="sliderMove" @change="sliderMove"/>
					</view>
				
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
	import uCharts from '../../components/u-charts/u-charts.js';
	import  { isJSON } from '@/utils/checker.js';
	var _self;
	var canvaCandle=null;
	export default {
		data() {
			return {
				cWidth:'',
				cHeight:'',
				pixelRatio:1,
				itemCount:20,//x轴单屏数据密度
				sliderMax:50,
				textarea:''
			}
		},
		onLoad() {
			_self = this;
			//#ifdef MP-ALIPAY
			uni.getSystemInfo({
				success: function(res) {
					if (res.pixelRatio > 1) {
						//正常这里给2就行，如果pixelRatio=3性能会降低一点
						//_self.pixelRatio =res.pixelRatio;
						_self.pixelRatio = 2;
					}
				}
			});
			//#endif
			this.cWidth = uni.upx2px(750);
			this.cHeight = uni.upx2px(500);
			this.getServerData();
		},
		methods: {
				getServerData(){
					uni.request({
						url: this.baseUrl+'/share/simulation',
						data:{
							"code":"300022.sz"
						},
						success: function(res) {
							console.log(res.data.data)
							let Candle={categories:[],series:[]};
							//这里我后台返回的是数组，所以用等于，如果您后台返回的是单条数据，需要push进去
							Candle.categories=res.data.data.Candle.categories;
							Candle.series=res.data.data.Candle.series;
							_self.textarea = JSON.stringify(res.data.data.Candle);
							_self.showCandle("canvasCandle",Candle);
						},
						fail: () => {
							_self.tips="网络错误，小程序端请检查合法域名";
						},
					});
				},
				showCandle(canvasId,chartData){
					canvaCandle=new uCharts({
						$this:_self,
						canvasId: canvasId,
						type: 'candle',
						fontSize:11,
						padding:[15,15,0,15],
						legend:{
							show:true,
							padding:5,
							lineHeight:11,
							margin:8,
						},
						background:'#FFFFFF',
						pixelRatio:_self.pixelRatio,
						enableMarkLine: true,/***需要开启标记线***/
						categories: chartData.categories,
						series: chartData.series,
						animation: false,
						enableScroll: true,//开启图表拖拽功能
						xAxis: {
							disableGrid:true,//不绘制X轴网格线
							labelCount:4,//X轴文案数量
							type:'grid',
							gridType:'dash',
							itemCount:_self.itemCount,//可不填写，配合enableScroll图表拖拽功能使用，x轴单屏显示数据的数量，默认为5个
							scrollShow:true,//新增是否显示滚动条，默认false
							scrollAlign:'right',
							scrollBackgroundColor:'#F7F7FF',//可不填写，配合enableScroll图表拖拽功能使用，X轴滚动条背景颜色,默认为 #EFEBEF
							scrollColor:'#DEE7F7',//可不填写，配合enableScroll图表拖拽功能使用，X轴滚动条颜色,默认为 #A6A6A6
						},
						yAxis: {
							disabled:true,
							gridType:'dash',
							splitNumber:5,
							format:(val)=>{return val.toFixed(2)}
						},
						width: _self.cWidth*_self.pixelRatio,
						height: _self.cHeight*_self.pixelRatio,
						dataLabel: false,
						dataPointShape: true,
						extra: {
							candle:{
								color:{
									upLine:'#f04864',
									upFill:'#f04864',
									downLine:'#2fc25b',
									downFill:'#2fc25b'
								},
								average:{
									show:true,
									name:['MA5','MA10','MA30'],
									day:[5,10,20],
									color:['#1890ff', '#2fc25b', '#facc14']
								}
							},
							tooltip:{
								bgColor:'#000000',
								bgOpacity:0.7,
								gridType:'dash',
								dashLength:5,
								gridColor:'#1890ff',
								fontColor:'#FFFFFF',
								horizentalLine:true,
								xAxisLabel:true,
								yAxisLabel:true,
								labelBgColor:'#DFE8FF',
								labelBgOpacity:0.95,
								labelAlign:'left',
								labelFontColor:'#666666'
							},
							markLine: {
								//  type: 'dash',
								//  dashLength: 5,
								//  data: [{
								// 	value:2150,
								// 	lineColor: '#f04864',
								// 	showLabel:true
								//  },{
								// 	value:2350,
								// 	lineColor: '#f04864',
								// 	showLabel:true
								// }]
							}
				}
					});
				},
				touchCandle(e){
					canvaCandle.scrollStart(e);
				},
				moveCandle(e) {
					canvaCandle.scroll(e);
					console.log(e)
				},
				touchEndCandle(e) {
					canvaCandle.scrollEnd(e);
					//下面是toolTip事件，如果滚动后不需要显示，可不填写
					canvaCandle.showToolTip(e, {
						format: function (item, category) {
							return category + ' ' + item.name + ':' + item.data 
						}
					});
					//这里演示了获取点击序列的方法，如需要将数据显示到canvas外面，可用此方法。
					var xx=canvaCandle.getCurrentDataIndex(e);
					//console.log(canvaCandle.opts.series[0].data[xx]);
					//下面是计算好的MA均线集合，想要点击序列中的当前数据，需要自己遍历seriesMA
					//console.log(canvaCandle.opts.seriesMA);
				},
				tapButton(type){
					let step=5;
					if(type=='in'){
						_self.itemCount -= step;
						if(_self.itemCount<=5){
							_self.itemCount=5;
						}
					}else{
						_self.itemCount += step;
						if(_self.itemCount>=_self.sliderMax){
							_self.itemCount=_self.sliderMax;
						}
					}
					_self.zoomCandle(_self.itemCount);
				},
				sliderMove(e){
					_self.itemCount=e.detail.value;
					_self.zoomCandle(e.detail.value);
				},
				zoomCandle(val) {
					canvaCandle.zoom({
						itemCount: val
					});
				},
				changeData(){
					if(isJSON(_self.textarea)){
						let newdata=JSON.parse(_self.textarea);
						canvaCandle.updateData({
							series: newdata.series,
							categories: newdata.categories
						});
					}else{
						uni.showToast({
							title:'数据格式错误',
							image:'../../../static/images/alert-warning.png'
						})
					}
				},
				handerBuy(){
		
					if(isJSON(_self.textarea)){
						
						let newdata=JSON.parse(_self.textarea);
					
						newdata.categories.push(newdata.categories[2])
						newdata.series[0].data.push(newdata.series[0].data[2])
						canvaCandle.updateData({
							series: newdata.series,
							categories: newdata.categories,
							scrollPosition:"right"
						});
						_self.textarea = JSON.stringify(newdata);
						// canvaCandle.scrollEnd()
					}else{
						uni.showToast({
							title:'数据格式错误',
							image:'../../../static/images/alert-warning.png'
						})
					}
					
				}
			}
		
		
	}
</script>

<style>
	page{background:#F2F2F2;width: 750upx;overflow-x: hidden;}
	.qiun-padding{padding:2%; width:96%;}
	.qiun-wrap{display:flex; flex-wrap:wrap;}
	.qiun-rows{display:flex; flex-direction:row !important;}
	.qiun-columns{display:flex; flex-direction:column !important;}
	.qiun-common-mt{margin-top:10upx;}
	.qiun-bg-white{background:#FFFFFF;}
	.qiun-title-bar{width:96%; padding:10upx 2%; flex-wrap:nowrap;}
	.qiun-title-dot-light{border-left: 10upx solid #0ea391; padding-left: 10upx; font-size: 32upx;color: #000000}
	/* 通用样式 */
	.qiun-charts{width: 750upx; height:500upx;background-color: #FFFFFF;}
	.charts{
		left: 25upx;
		width: 700upx;
		height:500upx;
		background-color: #FFFFFF;
		}
		
	.header {
		display:flex;
		flex-wrap:wrap;

	}
	.header label{
		display:flex;
		flex-wrap:wrap;
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
