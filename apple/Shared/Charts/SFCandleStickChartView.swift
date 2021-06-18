//
//  SFCandleStickChartView.swift
//  apple
//
//  Created by admin on 2021/6/16.
//

import SwiftUI
import Charts

#if os(iOS)


struct SFCandleStickChartView: UIViewRepresentable {
    
    let entries:[CandleChartDataEntry]
    
    func makeUIView(context: Context) -> CandleStickChartView {
        return CandleStickChartView()
    }
    
    func updateUIView(_ uiView: CandleStickChartView, context: Context) {
        let dataset = CandleChartDataSet(entries: entries)
        uiView.data = CandleChartData(dataSet: dataset)
        formateDataset(dataSet: dataset)
    }
    
    func formateDataset(dataSet:CandleChartDataSet) {
        dataSet.decreasingColor = .red
        dataSet.decreasingFilled = true
        dataSet.increasingColor = .green
        dataSet.increasingFilled = true
        dataSet.shadowColorSameAsCandle = true
    }

}

#else

struct SFCandleStickChartView: NSViewRepresentable {
    let entries:[CandleChartDataEntry]
   
    func makeNSView(context: Context) -> CandleStickChartView {
        return CandleStickChartView()
    }
    
    func updateNSView(_ nsView: CandleStickChartView, context: Context) {
        let dataset = CandleChartDataSet(entries: entries)
        nsView.data = CandleChartData(dataSet: dataset)
    }

}

#endif
//
//extension SFCandleStickChartView{
//    func formateDataset(dataSet:CandleChartDataSet) {
//        dataSet.decreasingColor = .red2
//    }
//}



struct SFCandleStickChartView_Previews: PreviewProvider {
    static var previews: some View {
        SFCandleStickChartView(entries: Datyly.datylyeEntry(datylys: Datyly.testdata))
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
        [
            Datyly(date: "20210101", open: 1.00, close: 0.98, hight: 1.02, low: 0.97),
            Datyly(date: "20210102", open: 0.98, close: 0.99, hight: 1.00, low: 0.98),
            Datyly(date: "20210103", open: 1.00, close: 0.98, hight: 1.02, low: 0.97),
            Datyly(date: "20210104", open: 1.00, close: 0.98, hight: 1.02, low: 0.97),
            Datyly(date: "20210105", open: 1.00, close: 0.98, hight: 1.02, low: 0.97),
            Datyly(date: "20210106", open: 1.00, close: 0.98, hight: 1.02, low: 0.97),
            Datyly(date: "20210107", open: 1.00, close: 0.98, hight: 1.02, low: 0.97),
            Datyly(date: "20210108", open: 1.00, close: 0.98, hight: 1.02, low: 0.97),
            Datyly(date: "20210109", open: 1.00, close: 0.98, hight: 1.02, low: 0.97),
            Datyly(date: "20210110", open: 1.00, close: 0.98, hight: 1.02, low: 0.97),
            Datyly(date: "20210111", open: 1.00, close: 0.98, hight: 1.02, low: 0.97)
        ]
    }
    
}
