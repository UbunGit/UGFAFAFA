/*
 * uCharts组件 默认配置文件，如有修改，更新前请备份此文件！！
 * Copyright (c) 2021 QIUN秋云 https://www.ucharts.cn All rights reserved.
 * Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
 * 
 * uCharts官方网站
 * https://www.uCharts.cn
 * 
 * 开源地址:
 * https://gitee.com/uCharts/uCharts
 * 
 * uni-app插件市场地址：
 * http://ext.dcloud.net.cn/plugin?id=271
 * 
 */
module.exports = {
	"type":["pie","ring","rose","word","funnel","map","arcbar","line","column","area","radar","gauge","candle","mix","point","bubble"],
	"categories":["line","column","area","radar","gauge","candle","mix","point","bubble"],
	//以上数据请勿改动，下面是自定义默认配置，请添加项目所需的个性配置
	"pie":{
		type: 'pie',
		padding:[15,15,0,15],
		legend:{
			show:true,
			padding:5,
			lineHeight:11,
			margin:0,
		},
		dataLabel: true,
		extra: {
			pie: {
		    border:true,
		    borderColor:'#FFFFFF',
		    borderWidth:3
			}
		}
	},
	"ring":{
		type: 'ring',
		padding:[5,5,5,5],
		legend:{
			show:true,
			position:'right',
			float:'center',
			itemGap:10,
			padding:5,
			lineHeight:26,
			margin:5,
			borderWidth :1
		},
		disablePieStroke: true,
		dataLabel: true,
		subtitle: {
			name: '70%',
			color: '#7cb5ec',
			fontSize: 25,
		},
		title: {
			name: '收益率',
			color: '#666666',
			fontSize: 15,
		},
		extra: {
			pie: {
			  offsetAngle: 0,
			  ringWidth: 40,
			  labelWidth:15
			}
		}
	},
	"rose":{
		type: 'rose',
		padding:[15,15,0,15],
		legend:{
			show:true,
			padding:5,
			lineHeight:11,
			margin:0,
		},
		dataLabel: true,
		extra: {
			rose: {
				type:'area',
				minRadius:50,
				activeOpacity:0.5,
				offsetAngle:0,
				labelWidth:15
			}
		}
	},
	"word":{
		type: 'word',
		extra: {
			word: {
				type: 'normal'
			}
		}
	},
	"funnel":{
		type: 'funnel',
		padding:[15,15,0,15],
		legend:{
			show:true,
			padding:5,
			lineHeight:11,
			margin:0,
		},
		dataLabel: true,
		extra: {
			funnel: {
		    border:true,
		    borderWidth:2,
		    borderColor:'#FFFFFF'
			}
		}
	},
	"map":{
		type: 'map',
		padding:[0,0,0,0],
		legend:{
			show:false
		},
		dataLabel:true,
		extra: {
			map: {
		    border:true,
		    borderWidth:1,
		    borderColor:'#666666',
		    fillOpacity:0.6
			}
		}
	},
	"arcbar":{
		type: 'arcbar',
		legend:{show:false},
		dataLabel: true,
		title: {
			name: "百分比",
			color: '#00FF00',
			fontSize: 25
		},
		subtitle: {
			name: "默认标题",
			color: '#666666',
			fontSize: 15
		},
		extra: {
			arcbar:{
				type:'default',
				width: 12,
			}
		}
	},
	"line":{
		type: 'line',
		padding:[15,30,0,15],
		legend:{
			show:true,
			padding:5,
			lineHeight:11,
			margin:0,
		},
		dataLabel: false,
		dataPointShape:true,
		xAxis: {
			disableGrid: true,
			labelCount: 4
		},
		yAxis: {
			gridType: 'dash',
			gridColor: '#CCCCCC',
			dashLength: 8,
			splitNumber: 4,
			format: val => {
				return val.toFixed(1);
			}
		},
		extra: {
			line:{
				type: 'straight'
			}
		}
	},
	"column":{
		type: 'column',
		padding:[35,5,0,15],
		legend:{
			show:true,
			padding:5,
			lineHeight:11,
			margin:0,
		},
		animation: true,
		dataLabel: true,
		xAxis: {
			disableGrid:true,
			labelCount: 4
		},
		yAxis: {
		  data:[{
		    position:'right',
				axisLine:false,
		    format:(val)=>{return val.toFixed(1)},
		  }]
		},
		extra: {
			column: {
				type:'group',
				width:20
			}
		}
	},
	"area":{
		type: 'area',
		padding:[0,15,10,15],
		legend:{
			show:true,
			position:'top',
			float:'center',
			itemGap:30,
			padding:5,
			lineHeight:18,
			margin:0,
		},
		dataLabel:false,
		dataPointShape:true,
		xAxis: {
			type:'grid',
			gridColor:'#CCCCCC',
			gridType:'dash',
			dashLength:8,
		},
		yAxis: {
			gridType:'dash',
			gridColor:'#CCCCCC',
			dashLength:8,
			splitNumber:5,
		},
		extra: {
			area:{
				type: 'curve',
				opacity:0.2,
				addLine:true,
				width:2,
				gradient:false
			}
		}
	},
	"radar":{
		type: 'radar',
		padding:[15,15,0,15],
		legend:{
			show:true,
			padding:5,
			lineHeight:11,
			margin:0,
		},
		animation: true,
		dataLabel: true,
		extra: {
			radar: {
				max: 200,
				gridType:'radar'//radar或者circle可选，网格样式，默认radar
			}
		}
	},
	"gauge":{
		type: 'gauge',
		legend:{show:false},
		animation: true,
		dataLabel: true,
		title: {
			name: "字符串类型",
			color: '#00FF00',
			fontSize: 25,
			offsetY:50,
		},
		subtitle: {
			name: "字符串类型",
			color: '#666666',
			fontSize: 15,
			offsetY:-50,
		},
		extra: {
			gauge:{
				type:'default',
				width: 30,
				startAngle:0.75,
				endAngle:0.25,
				startNumber:0,
				endNumber:100,
				splitLine:{
					fixRadius:0,
					splitNumber:10,
					width: 30,
					color:'#FFFFFF',
					childNumber:5,
					childWidth:30*0.4,
				},
				pointer:{
					width: 30*0.8,
					color:'auto'
				}
			}
		}
	},
	"candle":{
		type: 'candle',
		padding:[15,15,0,15],
		legend:{
			show:true,
			padding:5,
			lineHeight:11,
			margin:8,
		},
		enableMarkLine: true,
		enableScroll: true,
		dataLabel: false,
		dataPointShape: true,
		xAxis: {
			disableGrid:true,
			labelCount:4,
			itemCount:5,
			scrollShow:true,
			scrollAlign:'right',
		},
		yAxis: {
			gridType:'dash',
			splitNumber:5,
			format:(val)=>{return val.toFixed(0)}
		},
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
		    type: 'dash',
		    dashLength: 5,
		    data: [{
		      value:2150,
		      lineColor: '#f04864',
		      showLabel:true
		    },{
		      value:2350,
		      lineColor: '#f04864',
		      showLabel:true
		    }]
		  }
		}
	},
	"mix":{
		type: 'mix',
		padding:[5,5,0,5],
		legend:{
			show:true,
		  position:'bottom',
		  float:'center',
			padding:5,
			lineHeight:11,
			margin:6,
		},
		enableScroll: true,
		dataLabel: true,
		dataPointShape: true,
		xAxis: {
			disableGrid:false,
			type:'grid',
			gridType:'dash',
			itemCount:4,
			scrollShow:true,
			scrollAlign:'left',
		},
		yAxis: {
		  data:[{
		    calibration:true,
		    position:'left',
		    title:'折线',
		    titleFontSize:12,
		    format:(val)=>{return val.toFixed(0)+'度'}
		  },{
		    calibration:true,
		    position:'right',
		    min:0,
		    max:200,
		    title:'柱状图',
		    titleFontSize:12,
		    format:(val)=>{return val.toFixed(0)+'元'}
		  },{
		    calibration:true,
		    position:'right',
		    min:0,
		    max:200,
		    title:'点',
		    titleFontSize:12
		  }],
		  showTitle:true,
			gridType:'dash',
			dashLength:4,
			splitNumber:5
		},
		extra: {
		  column:{
		    width:20
		  },
			tooltip:{
				showBox:false,
				bgColor:'#000000',
				bgOpacity:0.7,
				gridType:'dash',
				dashLength:8,
				gridColor:'#1890ff',
				fontColor:'#FFFFFF',
				horizentalLine:true,
				xAxisLabel:true,
				yAxisLabel:true,
				labelBgColor:'#DFE8FF',
				labelBgOpacity:0.95,
				labelAlign:'left',
				labelFontColor:'#666666'
			}
		}
	},
	"point":{
		type: 'point',
		padding:[15,30,0,15],
		legend:{
			show:true
		},
		dataLabel: false,
		dataPointShape:true,
		xAxis: {
			disableGrid: true,
			labelCount: 4
		},
		yAxis: {
			gridType: 'dash',
			gridColor: '#CCCCCC',
			dashLength: 8,
			splitNumber: 4,
			format: val => {
				return val.toFixed(1);
			}
		},
		extra: {
			point:{
			}
		}
	},
	"bubble":{
		type: 'bubble',
		padding:[15,30,0,15],
		legend:{
			show:true
		},
		dataLabel: true,
		xAxis: {
			disableGrid: true,
			labelCount: 4
		},
		yAxis: {
			gridType: 'dash',
			gridColor: '#CCCCCC',
			dashLength: 8,
			splitNumber: 4,
			format: val => {
				return val.toFixed(1);
			}
		},
		extra: {
			bubble:{
			}
		}
	}
}