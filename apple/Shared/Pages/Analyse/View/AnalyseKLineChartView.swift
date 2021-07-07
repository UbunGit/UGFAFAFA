//
//  AnalyseKLineChartView.swift
//  apple
//
//  Created by admin on 2021/7/7.
//

import SwiftUI
import Charts

class AnalyseKLineChart: SFCombinedChart {
    
    @Published var dailys:[Daily] = []
    @Published var x_date:String = Date.init().toString("yyyyMMdd") ?? ""{
        didSet{
            dbDaily()
        }
    }
    var code:String = ""{
        didSet{
            Daily.reqData(code: code) { error in
                print("error")
            }
            dbDaily()
        }
    }
    
    
    override func updateChartView(chartView: CombinedChartView) {
        super .updateChartView(chartView: chartView)
        let combinedata = CombinedChartData()
       
        combinedata.lineData = LineChartData(dataSet: lineDataSet)
        combinedata.candleData = CandleChartData(dataSet: dataSet)
        chartView.data = combinedata
        

        chartView.setVisibleXRange(minXRange: 30, maxXRange: 30)
        let index:Double = Double( dailys.firstIndex {
           return $0.date == x_date
        } ?? 0)
        chartView.moveViewToX(index)
    }
    
    var maxcount:Int{
        Int(chartView.bounds.size.width/4)
    }
    
    
    var dataSet:CandleChartDataSet{
       
        let dataset = CandleChartDataSet(entries: Daily.candleChartDataEntry(datylys: dailys))
        styleDataSet(dataSet: dataset)
        return dataset
        
    }
    var lineDataSet:LineChartDataSet{
        let dataset = LineChartDataSet(entries: Daily.maDataEntry(ma:10, datylys: dailys))
        
        dataset.mode = .cubicBezier
        dataset.drawCirclesEnabled = false
        return dataset
    }
    func dbDaily() {
        var tdate:String = (x_date.toDate("yyyyMMdd")?.addingTimeInterval(-30*24*60*60).toString("yyyyMMdd"))!
        if dailys.count == 0 {
            tdate = (x_date.toDate("yyyyMMdd")?.addingTimeInterval(-99*24*60*60).toString("yyyyMMdd"))!
        }
        
        dailys = try! Daily.select(keys: {
            Daily.sqlKeys
        }, fitter: {
            "code=\"\(code)\" and date>\"\(tdate)\""
        }, orderby: {
            "date"
        }, limit: {
            100
        }, offset: {
            0
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
        x_date = dailys[lowestdata].date
        print(x_date)
    }
}
struct AnalyseKLineChartView: View {
    @Binding var code:String
    @StateObject var obser = AnalyseKLineChart()
    var body: some View {
        VStack{
           
            SFCombinedChartView(obser: obser)
        }
        .onChange(of: code, perform: { value in
            obser.code = code
        })
        .onAppear(){
            obser.code = code
        }
        
    }
}

struct AnalyseKLineChartView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseKLineChartView(code: .constant("0"))
    }
}
