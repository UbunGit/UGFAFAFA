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

    @StateObject var obser = SFUIAnalyseCharts()
//    @StateObject var amountObser = AnalyseAmountChart(bsPoint:.co)
    
    var body: some View {
        VStack{
      
            
            SFUIAnalyseChartsView(obser: obser)
                
                .frame(width: KWidth, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            BSPointView(bspoint: $obser.bspoint)
                .padding()
                .frame(width: KWidth, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            ZoneView(zones: $obser.zones)
                .padding()
                .frame(width: KWidth, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
           
            
        }
        .onChange(of: code, perform: { value in
            obser.code = code
  
        })
        .onChange(of: cacheId, perform: { value in
          
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
