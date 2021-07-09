//
//  SFBarChartView.swift
//  apple
//
//  Created by admin on 2021/7/8.
//

import SwiftUI
import Charts



class SFBarChart:ObservableObject,ChartViewDelegate {
    
    var chartView: BarChartView

    init() {
   
        self.chartView = BarChartView()
        self.chartView.delegate = self
    }
    func updateChartView(chartView:BarChartView) {
        
        styleXAxis()
        stylexYAxis(axis: chartView.getAxis(.left))
        stylexYAxis(axis: chartView.getAxis(.right))
        styleChartView()
        styleLegend()
       
    }
    
}
extension SFBarChart{
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
struct SFBarChartView: UIViewRepresentable {
    
    @ObservedObject var obser:SFBarChart
    
    func makeUIView(context: Context) -> BarChartView {

        return obser.chartView
    }
    
    func updateUIView(_ uiView: BarChartView, context: Context) {
        obser.updateChartView(chartView: uiView)

    }

}

#else

struct SFBarChartView: NSViewRepresentable {
    
    @ObservedObject var obser:SFBarChart
  
    func makeNSView(context: Context) -> BarChartView {
        return chartView
    }
    
    func updateNSView(_ nsView: BarChartView, context: Context) {
        obser.updateChartView(chartView: uiView)
 
    }
    
}

#endif

struct SFBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        SFBarChartView(obser: SFBarChart())
    }
}
