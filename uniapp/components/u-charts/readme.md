# uCharts JSSDK说明
1、如不使用uCharts组件，可直接引用u-charts.js，打包编译后会`自动压缩`，压缩后体积约为`90kb`。
2、如果90kb的体积仍需压缩，请手动删除u-charts.js内您不需要的图表类型，如k线图candle。
3、config.js为uCharts组件的用户配置文件，升级前请`自行备份config.js`文件，以免被强制覆盖。
4、demodata.json为标准数据格式，仅供演示使用。
5、mapdata.json为地图数据格式，遵循geoJson地图数据交换格式参考：http://datav.aliyun.com/tools/atlas/