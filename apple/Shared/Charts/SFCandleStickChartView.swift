//
//  SFCandleStickChartView.swift
//  apple
//
//  Created by admin on 2021/6/16.
//

import SwiftUI
import Charts

#if os(iOS)


struct SFCandleStickChartView: UIViewRepresentable {
    
    let entries:[CandleChartDataEntry]
    
    func makeUIView(context: Context) -> CandleStickChartView {
        return CandleStickChartView()
    }
    
    func updateUIView(_ uiView: CandleStickChartView, context: Context) {
        let dataset = CandleChartDataSet(entries: entries)
        uiView.data = CandleChartData(dataSet: dataset)
        uiView.xAxis.labelPosition = .bottom
        forrmatLineChartView(chartView: uiView)
        formateLineChartXaxis(axis: uiView.xAxis)
        formateYAxis(axis: uiView.getAxis(.left))
        formateYAxis(axis: uiView.getAxis(.right))
        formateLegend(legend: uiView.legend)
        formateDataset(dataSet: dataset)
    }
    
    func formateDataset(dataSet:CandleChartDataSet) {
        dataSet.decreasingColor = .red
        dataSet.decreasingFilled = true
        dataSet.increasingColor = .green
        dataSet.increasingFilled = true
        dataSet.shadowColorSameAsCandle = true
    }
    
}

#else

struct SFCandleStickChartView: NSViewRepresentable {
    let entries:[CandleChartDataEntry]
    
    func makeNSView(context: Context) -> CandleStickChartView {
        return CandleStickChartView()
    }
    
    func updateNSView(_ nsView: CandleStickChartView, context: Context) {
        let dataset = CandleChartDataSet(entries: entries)
        nsView.data = CandleChartData(dataSet: dataset)
        forrmatLineChartView(chartView: nsView)
        formateLineChartXaxis(axis: nsView.xAxis)
        formateYAxis(axis: nsView.getAxis(.left))
        formateYAxis(axis: nsView.getAxis(.right))
        formateLegend(legend: nsView.legend)
    }
    
}

#endif
extension SFCandleStickChartView{
    
    
    func forrmatLineChartView(chartView:CandleStickChartView)  {
        // 禁止Y轴的滚动与放大
        chartView.scaleYEnabled = false
        chartView.dragYEnabled = false
        // 允许X轴的滚动与放大
        chartView.dragXEnabled = true
        chartView.scaleXEnabled = true
        // X轴动画
        chartView.animate(xAxisDuration: 0.35);
        
        // 边框
        chartView.borderLineWidth = 0.5;
        chartView.drawBordersEnabled = true
 
    }
    
    func formateLineChartXaxis(axis:Charts.XAxis) {

        axis.labelPosition = .bottom
        axis.axisLineWidth = 1
        axis.gridLineWidth = 0.5
        axis.gridColor = .black.withAlphaComponent(0.2)
//        axis.labelTextColor = .label
    }
    
    func formateYAxis(axis:Charts.YAxis) {
//        axis.labelTextColor = .label
        axis.axisLineWidth = 1
        axis.gridLineWidth = 0.5
        axis.gridColor = .black.withAlphaComponent(0.1)
    }
    
    func formateLegend(legend:Charts.Legend){
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.xEntrySpace = 4
        legend.yEntrySpace = 4
        legend.yOffset = 10
    }
}




struct SFCandleStickChartView_Previews: PreviewProvider {
    static var previews: some View {
        SFCandleStickChartView(entries: Datyly.datylyeEntry(datylys: Datyly.testdata))
    }
}

struct Datyly {
    var date:String
    var open:Double
    var close:Double
    var hight:Double
    var low:Double
    static func datylyeEntry(datylys:[Datyly])->[CandleChartDataEntry]{
        return datylys.map { item in
            return CandleChartDataEntry(
                x:Double(item.date)!,
                shadowH: item.hight,
                shadowL: item.low,
                open: item.open,
                close: item.close
            )
        }
    }
    
    static var testdata:[Datyly]{
        let datylys = (0..<30).map { i -> Datyly in
            
            return Datyly(date: "\(20210101+i)",
                          open: 1.00+Double(Double(arc4random_uniform(100))*0.01),
                   close: 1.00+Double(Double(arc4random_uniform(100))*0.01),
                   hight:1.00+Double(Double(arc4random_uniform(100))*0.01),
                   low: 1.00+Double(Double(arc4random_uniform(100))*0.01)
            )
            
        }
        return datylys
        
    }
    
}
