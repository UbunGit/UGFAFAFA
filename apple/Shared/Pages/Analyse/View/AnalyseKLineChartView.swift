//
//  AnalyseKLineChartView.swift
//  apple
//
//  Created by admin on 2021/7/7.
//

import SwiftUI
import Charts




class AnalyseAmountChart: SFBarChart {

}


struct AnalyseKLineChartView: View {
    
    @Binding var code:String
    @Binding var cacheId:Int
    @StateObject var obser = AnalyseKLineChart()
//    @StateObject var amountObser = AnalyseAmountChart(bsPoint:.co)
    
    var body: some View {
        VStack{
           
            SFCombinedChartView(obser: obser)
                .frame( height: 400)
            
//            SFBarChartView(obser: amountObser)
  
            BSPointView(bspoint: $obser.bspoint)
            .padding()
           
            
        }
        .onChange(of: code, perform: { value in
            obser.code = code
            obser.cacheId = cacheId
        })
        .onAppear(){
            obser.code = code
            obser.cacheId = cacheId
        }
        
    }
}



struct AnalyseKLineChartView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseKLineChartView(code: .constant("0"),cacheId: .constant(0))
    }
}
