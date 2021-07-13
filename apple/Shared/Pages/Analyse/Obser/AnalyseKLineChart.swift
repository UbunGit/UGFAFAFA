//
//  AnalyseKLineChart.swift
//  apple
//
//  Created by admin on 2021/7/8.
//

import Foundation
import Charts
class AnalyseKLineChart: SFCombinedChart {
    
    @Published var dailys:[Daily] = []
    @Published var bspoint:[BSModen] = []
    @Published var x_mindate:String = Date.init().toString("yyyyMMdd") ?? ""{
        didSet{
            dbDaily()
        }
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
            dbDaily()
        }
    }
    
    
    override func updateChartView(chartView: CombinedChartView) {
        guard dailys.count>0 else {
            return
        }
        super .updateChartView(chartView: chartView)
        chartView.setVisibleXRange(minXRange: 30, maxXRange: 30)
       
        chartView.getAxis(.right).labelCount = 3
        let combinedata = CombinedChartData()
        let tlinDataSets =  lineDataSets + zoneDataSet(datylys: dailys)

        combinedata.lineData = LineChartData(dataSets: tlinDataSets)
        combinedata.candleData = CandleChartData(dataSet: dataSet)
        combinedata.barData = BarChartData(dataSets: amountDataSet(datylys: dailys))
        combinedata.scatterData = bsScatterData(datylys: dailys)
        chartView.data = combinedata
        
       
        
        let index:Double = Double( dailys.firstIndex {
           return $0.date == x_mindate
        } ?? 0)
        chartView.moveViewToX(index)
    }
    
    var maxcount:Int{
        Int(chartView.bounds.size.width/4)
    }
    
    var dataSet:CandleChartDataSet{
       
        let dataset = CandleChartDataSet(entries: candleChartDataEntry(datylys: dailys))
        styleDataSet(dataSet: dataset)
    
        return dataset
        
    }
    
    var lineDataSets:[LineChartDataSet]{
        
        let dataset5 = LineChartDataSet(entries: maDataSets(ma:5, datylys: dailys),label: "5")
        dataset5.mode = .cubicBezier
        dataset5.drawCirclesEnabled = false
        dataset5.drawFilledEnabled = false
        dataset5.drawValuesEnabled = false
        dataset5.fillColor = .yellow.withAlphaComponent(0.1)
        dataset5.colors = [.yellow]
        
        let dataset10 = LineChartDataSet(entries: maDataSets(ma:10, datylys: dailys),label: "10")
        dataset10.mode = .cubicBezier
        dataset10.drawCirclesEnabled = false
        dataset10.drawValuesEnabled = false
        
     
        
        return [dataset5,dataset10]
    }
    
    func dbDaily() {
        var tdate:String = (x_mindate.toDate("yyyyMMdd")?.addingTimeInterval(-30*24*60*60).toString("yyyyMMdd"))!
        if dailys.count == 0 {
            tdate = (x_mindate.toDate("yyyyMMdd")?.addingTimeInterval(-99*24*60*60).toString("yyyyMMdd"))!
        }
        dailys = try! Daily.select(fitter: {
            "code=\"\(code)\" and date>\"\(tdate)\""
        }, orderby: {
            "date"
        }, limit: {
            100
        }, offset: {
            0
        })
        
       
        
        let mindate:String = dailys.first?.date ?? Date.init().toString("yyyyMMdd")!
        let maxdate:String = dailys.last?.date ?? Date.init().toString("yyyyMMdd")!
        bspoint = try! BSModen.select(
            fitter: {
                "code=\"\(code)\" and cacheId=\(cacheId) and date>=\"\(mindate)\" and date<=\"\(maxdate)\""
            }, orderby: {
                "date"
            }, limit: {
            nil
            }, offset: {
                nil
            })
        
    }
    
    /// 样式
    func styleDataSet(dataSet:CandleChartDataSet) {
        dataSet.label = "\(code)"
        dataSet.decreasingColor = .green
        dataSet.decreasingFilled = true
        dataSet.increasingColor = .red
        dataSet.increasingFilled = true
        dataSet.shadowColorSameAsCandle = true
    }
    override func styleXAxis() {
        super.styleXAxis()
        let xaxis = chartView.xAxis
        xaxis.valueFormatter = IndexAxisValueFormatter.init(
            values:dailys.map { $0.date.toDate("yyyyMMdd")?.toString("yyyy-MM-dd") ?? "--" }
        )
        xaxis.axisMaximum = Double(dailys.count+1)

    }
    
    /// delegate
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
 
    }
    // 图表缩放
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        print("scaleX:\(scaleX)")
        print("scaleY:\(scaleY)")
    }
    // 图标被移动
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {

    }
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        var lowestdata:Int = Int(self.chartView.lowestVisibleX)
    
        if (lowestdata <= 0 && lowestdata >= dailys.count ) {
            lowestdata = 1
        }
        x_mindate = dailys[lowestdata].date
        print(x_mindate)
    }
}

extension AnalyseKLineChart{
    
    func zoneDataSet(datylys:[Daily])->[LineChartDataSet]{
        return []
        if (datylys.count <= 0) {
            return []
        }
        let begin:Int = 35
        let end:Int = begin + 10
        
        let entrys = datylys[begin...end].enumerated().map { (index,item) in
            
            return ChartDataEntry(x: Double(index+begin), y: Double(item.close),  data: item)
        }

        let dataSet = LineChartDataSet(entries: entrys,label: "zone")
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.drawFilledEnabled = true
        dataSet.drawValuesEnabled = false
        dataSet.fillColor =  (datylys[begin].close<=datylys[end].close) ? .red.withAlphaComponent(0.3) : .green.withAlphaComponent(0.3)
        dataSet.colors = (datylys[begin].close>datylys[end].close) ? [.green] :[.red]
        return [dataSet]
       
    }
    
    func amountDataSet(datylys:[Daily]) -> [BarChartDataSet] {
        var barColors:[NSUIColor] = []
        let entrys = dailys.enumerated().map { (index,item) -> BarChartDataEntry in
            let entry = BarChartDataEntry(x: Double(index), y: Double(item.amount/100000))
            barColors.append((item.open >= item.close) ? .green.withAlphaComponent(0.2) : .red.withAlphaComponent(0.2))
            return entry
        }
        let dataSet = BarChartDataSet(entries: entrys, label: "amount")
        dataSet.axisDependency = .right;
        dataSet.colors = barColors
        return [dataSet]
    }
    
    func bsScatterData(datylys:[Daily]) -> ScatterChartData{
        
        
        var colors:[NSUIColor] = []
        let entrys = bspoint.enumerated().map { (index, item) -> ChartDataEntry in
            colors.append(item.type==1 ? .orange : .blue)
            let sort:Int = datylys.firstIndex {$0.date == item.date} ?? 0
       
            return  ChartDataEntry(x: Double(sort), y: Double(datylys[sort].high))
            
        }
        let dataSet = ScatterChartDataSet(entries: entrys)
        dataSet.colors = colors
        dataSet.setScatterShape(.circle)
        return ScatterChartData(dataSet:dataSet)
        
    }
    
    func maDataSets(ma:Int,datylys:[Daily]) -> [ChartDataEntry] {
        return datylys.enumerated().map { (index,item) in
           
            var sum = item.close
            if index>ma{
                let tsum = datylys[index-ma..<index].reduce(0) { $0 + $1.close }
                sum = tsum/Float(ma)
            }
            return ChartDataEntry(x: Double(index), y: Double(sum),  data: item)
        }
    }
    
    func candleChartDataEntry(datylys:[Daily])->[CandleChartDataEntry]{
        return datylys.enumerated().map { (index,item) in
           
            return CandleChartDataEntry(
                x:Double(index),
                shadowH: Double(item.high),
                shadowL: Double(item.low),
                open: Double(item.open),
                close: Double(item.close),
                data: item
            )
        }
    }
}
