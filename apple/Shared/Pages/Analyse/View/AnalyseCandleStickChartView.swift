//
//  AnalyseCandleStickChartView.swift
//  apple
//
//  Created by admin on 2021/7/2.
//

import SwiftUI
import Charts
class AnalyseCandleStickChart: ObservableObject{
    
    @Published var dailys:[Daily] = []
    var entries:[CandleChartDataEntry]{
        get{
            Daily.datylyeEntry(datylys: dailys)
        }
    }
    
    func reloadDailys(code:String) {
        Daily.reqData(code: code) { error in
            self.dailys =  try! Daily.select(keys: {
                Daily.sqlKeys
            }, fitter: {
                "code=\"\(code)\""
            }, orderby: {
                "date"
            }, limit: {
                100
            }, offset: {
                1
            })
        }
       
    }
    
}

struct AnalyseCandleStickChartView:View {
    @Binding var code:String
    @StateObject var obser = AnalyseCandleStickChart()
    
    var body: some View{
        VStack{
            Text(code)
            SFCandleStickChartView(entries: obser.entries)
               
        }
        .onChange(of: code, perform: { value in
            obser.reloadDailys(code: code)
        })
      
    }
}

extension Daily{
    static func datylyeEntry(datylys:[Daily])->[CandleChartDataEntry]{
        return datylys.map { item in
            return CandleChartDataEntry(
                x:Double(datylys.i),
                shadowH: Double(item.high),
                shadowL: Double(item.low),
                open: Double(item.open),
                close: Double(item.close)
            )
        }
    }
}


struct AnalyseCandleStickChartView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseCandleStickChartView(code: .constant("000001.SZ"))
    }
}
