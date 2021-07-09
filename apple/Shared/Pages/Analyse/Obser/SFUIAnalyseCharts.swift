//
//  SFUIAnalyseCharts.swift
//  apple
//
//  Created by admin on 2021/7/9.
//

import Foundation
import Charts

class SFUIAnalyseCharts:ObservableObject,ChartViewDelegate {
    
    var chartView: AnalyseChartsView
    
    @Published var dailys:[Daily] = []
    @Published var bspoint:[BSModen] = []
    @Published var zones:[ZoneModen] = []
    
    var cacheDate:String?
    
    var x_mindate:String {
        if dailys.count<=0 {
            return Date.init().toString("yyyyMMdd")!
        }
        var lowestdata:Int = Int(self.chartView.kChartView.lowestVisibleX)
    
        if (lowestdata <= 0 || lowestdata >= dailys.count ) {
            lowestdata = 0
        }
        return dailys[lowestdata].date
    }
    
    var x_maxData:String{
        var highest:Int = Int(self.chartView.kChartView.highestVisibleX)
    
        if (highest <= 0 || highest >= dailys.count ) {
            highest = dailys.count-1
        }
        return dailys[highest].date
    }
   
    var code:String = ""{
        didSet{
            Daily.reqData(code: code) { error in
                print("error")
            }
      
        }
    }
    
    var cacheId:Int = 0{
        didSet{
            AnalyseDetails.reqData(code: code, cacheId: cacheId) { error in
                print("error")
            }
            updataDbdata()
        }
    }
    


    init() {
   
        chartView = AnalyseChartsView()
        chartView.kChartView.delegate = self
        chartView.amountChartView.delegate = self
    }
    
    
    func updateChartView(chartView: AnalyseChartsView) {
        guard dailys.count>0 else {
            return
        }
        styleKChartView()
        styleAmountChartView()
       
        kChartView.setVisibleXRange(minXRange: 30, maxXRange: 30)
        kChartView.getAxis(.right).labelCount = 3
        
        amountChartView.setVisibleXRange(minXRange: 30, maxXRange: 30)
      
        
        let combinedata = CombinedChartData()
        let tlinDataSets =  lineDataSets + zoneDataSet(datylys: dailys)

        combinedata.lineData = LineChartData(dataSets: tlinDataSets)
        combinedata.candleData = CandleChartData(dataSet: candleChartDataSet(datylys: dailys))
        
        combinedata.scatterData = bsScatterData(datylys: dailys)
        chartView.kChartView.data = combinedata
        
        chartView.amountChartView.data = BarChartData(dataSets: amountDataSet(datylys: dailys))
       
        
     
        
        
    }

}

/// style kChartView

extension SFUIAnalyseCharts{
    var kChartView:CombinedChartView{
        chartView.kChartView
    }
    func styleKChartView()  {
        styleKChartViewChartView()
        styleKChartViewXAxis()
        stylexKChartViewYAxis(axis: kChartView.getAxis(.left))
        stylexKChartViewYAxis(axis: kChartView.getAxis(.right))
        styleKChartViewLegend()
    }
    
    func styleKChartViewChartView()  {
        
        // 禁止Y轴的滚动与放大
        chartView.kChartView.scaleYEnabled = false
        chartView.kChartView.dragYEnabled = false
        // 允许X轴的滚动与放大
        chartView.kChartView.dragXEnabled = true
        chartView.kChartView.scaleXEnabled = true
    
        // 边框
        chartView.kChartView.borderLineWidth = 0.5;
        chartView.kChartView.drawBordersEnabled = true
    }

    func styleKChartViewXAxis() {
        let axis = kChartView.xAxis
        axis.labelPosition = .bottom
        axis.axisLineWidth = 1
        axis.gridLineWidth = 0.5
        axis.gridColor = .black.withAlphaComponent(0.2)
        axis.labelCount = 3
        axis.labelRotationAngle = -1
     
        axis.valueFormatter = IndexAxisValueFormatter.init(
            values:dailys.map { $0.date.toDate("yyyyMMdd")?.toString("yyyy-MM-dd") ?? "--" }
        )
        axis.axisMaximum = Double(dailys.count+1)
    }
    func stylexKChartViewYAxis(axis:YAxis) {
        axis.axisLineWidth = 1
        axis.gridLineWidth = 0.5
        axis.gridColor = .black.withAlphaComponent(0.1)
    }

  
    
    func styleKChartViewLegend(){
        let legend = kChartView.legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.xEntrySpace = 4
        legend.yEntrySpace = 4
        legend.yOffset = 10
        legend.enabled = false
    }
    
}

/// style amountChartView
extension SFUIAnalyseCharts{
    var amountChartView:BarChartView{
        return chartView.amountChartView
    }
    func styleAmountChartView()  {
        
        // 禁止Y轴的滚动与放大
        amountChartView.scaleYEnabled = false
        amountChartView.dragYEnabled = false
        // 允许X轴的滚动与放大
        amountChartView.dragXEnabled = true
        amountChartView.scaleXEnabled = true
    
        // 边框
        amountChartView.borderLineWidth = 0.5;
        amountChartView.drawBordersEnabled = true
        
        styleAmountChartViewXAxis()
        styleAmountChartViewYAxis(axis: kChartView.getAxis(.left))
        styleAmountChartViewYAxis(axis: kChartView.getAxis(.right))
        styleAmountChartViewLegend()
    }
    
    func styleAmountChartViewXAxis() {
        let axis = amountChartView.xAxis
        axis.labelPosition = .bottom
        axis.axisLineWidth = 1
        axis.gridLineWidth = 0.5
        axis.gridColor = .black.withAlphaComponent(0.2)
        axis.labelCount = 3
        axis.labelRotationAngle = -1
     
        axis.valueFormatter = IndexAxisValueFormatter.init(
            values:dailys.map { $0.date.toDate("yyyyMMdd")?.toString("yyyy-MM-dd") ?? "--" }
        )
        axis.axisMaximum = Double(dailys.count+1)
    }
    
    func styleAmountChartViewLegend(){
        let legend = amountChartView.legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.xEntrySpace = 4
        legend.yEntrySpace = 4
        legend.yOffset = 10
        legend.enabled = false
    }
    
    func styleAmountChartViewYAxis(axis:YAxis) {
        axis.axisLineWidth = 1
        axis.gridLineWidth = 0.5
        axis.gridColor = .black.withAlphaComponent(0.1)
    }
    
  
    
}

/// delegate
extension SFUIAnalyseCharts{
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
 
    }
    // 图表缩放
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        let srcMatrix = chartView.viewPortHandler.touchMatrix;
        kChartView.viewPortHandler .refresh(newMatrix: srcMatrix, chart: kChartView, invalidate: true)
        amountChartView.viewPortHandler.refresh(newMatrix: srcMatrix, chart: amountChartView, invalidate: true)
    }
    // 图标被移动
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        let srcMatrix = chartView.viewPortHandler.touchMatrix;
        kChartView.viewPortHandler .refresh(newMatrix: srcMatrix, chart: kChartView, invalidate: true)
        amountChartView.viewPortHandler.refresh(newMatrix: srcMatrix, chart: amountChartView, invalidate: true)
    }
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        if dailys.count<=0 {
            return
        }
        var lowestdata:Int = Int(self.chartView.kChartView.lowestVisibleX)
    
        if (lowestdata <= 0 || lowestdata >= dailys.count ) {
            lowestdata = 0
        }
        cacheDate =  dailys[lowestdata].date
  
        updataDbdata()
    }
}
