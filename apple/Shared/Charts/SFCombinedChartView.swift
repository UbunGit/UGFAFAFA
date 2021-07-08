//
//  SFCombinedChartView.swift
//  apple
//
//  Created by admin on 2021/7/7.
//

import SwiftUI
import Charts

class SFCombinedChart: ObservableObject,ChartViewDelegate {
    
    @State var chartView:CombinedChartView
    
    init() {
   
        self.chartView = CombinedChartView()
        self.chartView.delegate = self
    }
    
    func updateChartView(chartView:CombinedChartView) {
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


struct SFCombinedChartView: UIViewRepresentable {
    
    @ObservedObject var obser:SFCombinedChart
    
    func makeUIView(context: Context) -> CombinedChartView {

        return obser.chartView
    }
    
    func updateUIView(_ uiView: CombinedChartView, context: Context) {
        obser.updateChartView(chartView: uiView)

    }

}

#else

struct SFCombinedChartView: NSViewRepresentable {
    
    @ObservedObject var obser:SFCandleStickChart
  
    func makeNSView(context: Context) -> CandleStickChartView {
        return chartView
    }
    
    func updateNSView(_ nsView: CandleStickChartView, context: Context) {
        obser.updateChartView(chartView: uiView)
 
    }
    
}

#endif

struct SFCombinedChartView_Previews: PreviewProvider {
    static var previews: some View {
        SFCombinedChartView(obser: SFCombinedChart())
    }
}

