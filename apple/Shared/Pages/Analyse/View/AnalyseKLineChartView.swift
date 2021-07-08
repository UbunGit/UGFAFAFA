//
//  AnalyseKLineChartView.swift
//  apple
//
//  Created by admin on 2021/7/7.
//

import SwiftUI
import Charts
import UGSwiftKit






struct AnalyseKLineChartView: View {
    
    @Binding var code:String
    @Binding var cacheId:Int
    @StateObject var obser = AnalyseKLineChart()
    @StateObject var bobser = SFUIAnalyseCharts()
//    @StateObject var amountObser = AnalyseAmountChart(bsPoint:.co)
    
    var body: some View {
        VStack{
           
            SFCombinedChartView(obser: obser)
                .frame( height: 400)
            
            SFUIAnalyseChartsView(obser: bobser)
        
                .frame(width: KWidth, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
  
            BSPointView(bspoint: $obser.bspoint)
            .padding()
           
            
        }
        .onChange(of: code, perform: { value in
            obser.code = code
            obser.cacheId = cacheId
            bobser.code = code
            bobser.cacheId = cacheId
        })
        .onAppear(){
            obser.code = code
            obser.cacheId = cacheId
            bobser.code = code
            bobser.cacheId = cacheId
        }
        
    }
}



struct AnalyseKLineChartView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseKLineChartView(code: .constant("0"),cacheId: .constant(0))
    }
}
