//
//  SFCandleStickChartView.swift
//  apple
//
//  Created by admin on 2021/6/16.
//

import SwiftUI
import Charts

class SFCandleStickChart: ObservableObject,ChartViewDelegate {
    
    @State var chartView:CandleStickChartView
    
    init() {
        self.chartView = CandleStickChartView()
        self.chartView.delegate = self
    }
    
    func updateChartView(chartView:CandleStickChartView) {
        styleXAxis()
        stylexYAxis(axis: chartView.getAxis(.left))
        stylexYAxis(axis: chartView.getAxis(.right))
        styleChartView()
        styleLegend()
       
    }
    
    /// 样式
    func styleXAxis() {
        let axis = chartView.xAxis
        axis.labelPosition = .bottom
        axis.labelPosition = .bottom
        axis.axisLineWidth = 1
      
        axis.gridLineWidth = 0.5
        axis.gridColor = .black.withAlphaComponent(0.2)
        axis.labelCount = 3
        axis.labelRotationAngle = -1
    }
    func stylexYAxis(axis:YAxis) {
        axis.axisLineWidth = 1
        axis.gridLineWidth = 0.5
        axis.gridColor = .black.withAlphaComponent(0.1)
    }

    func styleChartView()  {
        
        // 禁止Y轴的滚动与放大
        chartView.scaleYEnabled = false
        chartView.dragYEnabled = false
        // 允许X轴的滚动与放大
        chartView.dragXEnabled = true
        chartView.scaleXEnabled = true
        // X轴动画
//        chartView.animate(xAxisDuration: 0.35);
    
        // 边框
        chartView.borderLineWidth = 0.5;
        chartView.drawBordersEnabled = true
    }
    
    func styleLegend(){
        let legend = chartView.legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.xEntrySpace = 4
        legend.yEntrySpace = 4
        legend.yOffset = 10
    }

}

#if os(iOS)


struct SFCandleStickChartView: UIViewRepresentable {
    
    @ObservedObject var obser:SFCandleStickChart
    
    func makeUIView(context: Context) -> CandleStickChartView {

        return obser.chartView
    }
    
    func updateUIView(_ uiView: CandleStickChartView, context: Context) {
        obser.updateChartView(chartView: uiView)
     
//        formateYAxis(axis: uiView.getAxis(.left))
//        formateYAxis(axis: uiView.getAxis(.right))
   
        
    }
    
 
    
}

#else

struct SFCandleStickChartView: NSViewRepresentable {
    
    @ObservedObject var obser:SFCandleStickChart
  
    func makeNSView(context: Context) -> CandleStickChartView {
        return chartView
    }
    
    func updateNSView(_ nsView: CandleStickChartView, context: Context) {
        obser.updateChartView(chartView: uiView)
 
    }
    
}

#endif

struct SFCandleStickChartView_Previews: PreviewProvider {
    static var previews: some View {
        SFCandleStickChartView(obser: SFCandleStickChart())
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
