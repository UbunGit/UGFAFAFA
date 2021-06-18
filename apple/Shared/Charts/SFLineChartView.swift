//
//  SFLineChartView.swift
//  apple (iOS)
//
//  Created by admin on 2021/6/17.
//

import SwiftUI
import Charts



#if os(iOS)
struct SFLineChartView:UIViewRepresentable{
    func makeUIView(context: Context) -> LineChartView {
        return LineChartView()
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        let data = LineChartData(dataSets: datasets)
        uiView.data = data
        forrmatLineChartView(chartView: uiView)
        formateLineChartXaxis(axis: uiView.xAxis)
        formateYAxis(axis: uiView.getAxis(.left))
        formateYAxis(axis: uiView.getAxis(.right))
        formateLegend(legend: uiView.legend)
    }
    
    let datasets:[LineChartDataSet]

}

#else

struct SFLineChartView:NSViewRepresentable {
    let datasets:[LineChartDataSet]
    func makeNSView(context: Context) -> LineChartView {
        return LineChartView()
    }
    
    func updateNSView(_ nsView: LineChartView, context: Context) {
 
        let data = LineChartData(dataSets: datasets)
        nsView.data = data
        forrmatLineChartView(chartView: nsView)
        formateLineChartXaxis(axis: nsView.xAxis)
        formateYAxis(axis: nsView.getAxis(.left))
        formateYAxis(axis: nsView.getAxis(.right))
        formateLegend(legend: nsView.legend)

    }
}

#endif

extension SFLineChartView{
    
    func forrmatLineChartView(chartView:LineChartView)  {
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



struct Earning {
    
    var date:Double
    var value:Double
    
    static func toChartDataEntrys(earnings:[Earning]) -> [ChartDataEntry]{
        return earnings.map { earning in
            return ChartDataEntry(x: earning.date, y: earning.value)
        }
    }
    
    static var testDatas:[Earning]{
        
      let earnings = (0..<30).map { i -> Earning in
         Earning(
            date: Double(20210101+i),
            value: Double(arc4random_uniform(5))
        )
      }
        return earnings
    }
}

let colors = ChartColorTemplates.vordiplom()[0...3]
struct SFLineChartView_Previews: PreviewProvider {
    static var previews: some View {
        
        let dasets = (0...4).map {index -> LineChartDataSet in
            let chartset = LineChartDataSet(entries: Earning.toChartDataEntrys(earnings: Earning.testDatas))
            chartset.mode = .horizontalBezier
            let color = colors[index % colors.count]
            chartset.setColor(color)
            chartset.label = "index_\(index)"
            chartset.circleRadius = 4
            chartset.circleHoleRadius = 2
            chartset.setCircleColor(color)
            chartset.lineWidth = 2
            return chartset
        }
        SFLineChartView(datasets: dasets)
            .preferredColorScheme(.light)
            .environment(\.sizeCategory, .small)
            
    }
}
