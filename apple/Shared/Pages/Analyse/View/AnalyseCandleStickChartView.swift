//
//  AnalyseCandleStickChartView.swift
//  apple
//
//  Created by admin on 2021/7/2.
//

import SwiftUI
import Charts

class AnalyseCandleStickChart: SFCandleStickChart{
    
    override var entries:[CandleChartDataEntry]{
        get{
            Daily.datylyeEntry(datylys: dailys)
        }
    }
    
    var code:String = ""{
        didSet{
            Daily.reqData(code: code) { error in
                print("error")
            }
      
        }
    }
    
    var xAxisValue:[String]{
        get{
            let values =  dailys.map { item in
                return item.date.toDate("yyyyMMdd")?.toString("yyyy-MM-dd") ?? "--"
            }
            return values
        }
    }
    
    var dailys:[Daily]{
        let dailys = try! Daily.select(keys: {
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
        let values =  dailys.map { item in
            return item.date.toDate("yyyyMMdd")?.toString("yyyy-MM-dd") ?? "--"
        }
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter.init(values: values)
        return dailys
    }

    
}

struct AnalyseCandleStickChartView:View {
    @Binding var code:String
    @StateObject var obser = AnalyseCandleStickChart()
    
    var body: some View{
        VStack{
            Text(code)
            SFCandleStickChartView(obser: obser)
               
              
        }
        .onChange(of: code, perform: { value in
            obser.code = code
        })
      
    }
}


extension Daily{
    static func datylyeEntry(datylys:[Daily])->[CandleChartDataEntry]{
        return datylys.enumerated().map { (index,item) in
           
            return CandleChartDataEntry(
                x:Double(index),
                shadowH: Double(item.high),
                shadowL: Double(item.low),
                open: Double(item.open),
                close: Double(item.close),
                data: item
            )
        }
    }
}





struct AnalyseCandleStickChartView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseCandleStickChartView(code: .constant("000001.SZ"))
    }
}
