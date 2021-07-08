//
//  AnalyseResultView.swift
//  apple
//
//  Created by admin on 2021/6/19.
//

import SwiftUI
import Charts

class AnalyseResult: ObservableObject {
    
    @Published var earning:[Earning]
    init() {
        self.earning = []
        self.loaddata()
    }
    func loaddata() {
        self.earning = Earning.testDatas
    }
    func reqdata()  {
        self.earning = Earning.testDatas
    }
}

let analyseResult = AnalyseResult()
struct AnalyseResultView:View {
    @ObservedObject var obser = analyseResult
    @Binding var historyId:Int
    @Binding var codes:[String]

    var body: some View{
        
        VStack{
           
            ScrollView(.vertical, showsIndicators: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/) {
                let count = codes.count>0 ? 1 : 0
                ForEach(0..<count, id: \.self) { index in
              
                    
                    AnalyseKLineChartView(code: $codes[index], cacheId:$historyId)
                        .frame(height: 600)
                       
                    
                }
        
        
            }
        }
        .onChange(of: historyId, perform: { value in
            analyseResult.reqdata()
        })
     
      
       
        
    }
    
    var chartset: [LineChartDataSet] {
        let chartset = LineChartDataSet(entries: Earning.toChartDataEntrys(earnings: obser.earning))
        chartset.mode = .horizontalBezier
        let color = colors[0 % colors.count]
        chartset.setColor(color)
        chartset.label = "index_\(0)"
        chartset.circleRadius = 4
        chartset.circleHoleRadius = 2
        chartset.setCircleColor(color)
        chartset.lineWidth = 2
        return [chartset]
    }
}

struct AnalyseResultView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseResultView(historyId: .constant(0), codes: .constant(["000001.SZ"]))
    }
}

