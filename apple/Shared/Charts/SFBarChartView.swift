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
