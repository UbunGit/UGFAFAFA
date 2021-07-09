//
//  SFUIAnalyseChartsView.swift
//  apple
//
//  Created by admin on 2021/7/8.
//

import SwiftUI
import Charts


extension SFUIAnalyseCharts{
   
    
    
    var lineDataSets:[LineChartDataSet]{
        
        let dataset5 = LineChartDataSet(entries: maDataSets(ma:5, datylys: dailys),label: "5")
        dataset5.mode = .cubicBezier
        dataset5.drawCirclesEnabled = false
        dataset5.drawFilledEnabled = false
        dataset5.drawValuesEnabled = false
        dataset5.fillColor = .yellow.withAlphaComponent(0.1)
        dataset5.colors = [.yellow]

        let dataset10 = LineChartDataSet(entries: maDataSets(ma:10, datylys: dailys),label: "10")
        dataset10.mode = .cubicBezier
        dataset10.drawCirclesEnabled = false
        dataset10.drawValuesEnabled = false



        return [dataset5,dataset10]
    }
    
    func maDataSets(ma:Int,datylys:[Daily]) -> [ChartDataEntry] {
        return datylys.enumerated().map { (index,item) in
           
            var sum = item.close
            if index>ma{
                let tsum = datylys[index-ma..<index].reduce(0) { $0 + $1.close }
                sum = tsum/Float(ma)
            }
            return ChartDataEntry(x: Double(index), y: Double(sum),  data: item)
        }
    }
    
    func zoneDataSet(datylys:[Daily])->[LineChartDataSet]{
      
        if (datylys.count <= 0) {
            return []
        }
        return zones.map { zone in
            
            let begin:Int = datylys.firstIndex { $0.date==zone.begin } ?? 0
            let end:Int = datylys.firstIndex { $0.date==zone.end }  ?? datylys.count-1
            
            let entrys = datylys[begin...end].enumerated().map { (index,item) in
                
                return ChartDataEntry(x: Double(index+begin), y: Double(item.close),  data: item)
            }

            let dataSet = LineChartDataSet(entries: entrys,label: "zone")
            dataSet.mode = .cubicBezier
            dataSet.drawCirclesEnabled = false
            dataSet.drawFilledEnabled = true
            dataSet.drawValuesEnabled = false
            dataSet.fillColor =  (datylys[begin].close<=datylys[end].close) ? .red.withAlphaComponent(0.3) : .green.withAlphaComponent(0.3)
            dataSet.colors = (datylys[begin].close>datylys[end].close) ? [.green] :[.red]
            return dataSet
        }
    }
    
    func bsScatterData(datylys:[Daily]) -> ScatterChartData{
        
        
        var colors:[NSUIColor] = []
        let entrys = bspoint.enumerated().map { (index, item) -> ChartDataEntry in
            colors.append(item.type==1 ? .orange : .blue)
            let sort:Int = datylys.firstIndex {$0.date == item.date} ?? 0
       
            return  ChartDataEntry(x: Double(sort), y: Double(datylys[sort].high))
            
        }
        let dataSet = ScatterChartDataSet(entries: entrys)
        dataSet.colors = colors
        dataSet.setScatterShape(.circle)
    
        return ScatterChartData(dataSet:dataSet)
        
    }
    func updataDbdata()  {
        var tdate:String = (x_mindate.toDate("yyyyMMdd")?.addingTimeInterval(-60*24*60*60).toString("yyyyMMdd"))!
        if dailys.count == 0 {
            tdate = (x_mindate.toDate("yyyyMMdd")?.addingTimeInterval(-99*24*60*60).toString("yyyyMMdd"))!
        }
        
        dailys = try! Daily.select(keys: {
            Daily.sqlKeys
        }, fitter: {
            "code=\"\(code)\" and date>\"\(tdate)\""
        }, orderby: {
            "date"
        }, limit: {
            90
        }, offset: {
            0
        })
        
//        let mindate:String = dailys.first?.date ?? Date.init().toString("yyyyMMdd")!
        let mindate = x_mindate
        let maxdate = x_maxData

        bspoint = try! BSModen.select(
            keys: {
                BSModen.sqlKeys
            }, fitter: {
                "code=\"\(code)\" and cacheId=\(cacheId) and date>=\"\(mindate)\" and date<=\"\(maxdate)\""
            }, orderby: {
                "date"
            }, limit: {
            nil
            }, offset: {
                nil
            })
        
        zones = try! ZoneModen.select(
            keys: {
                ZoneModen.sqlKeys
            }, fitter: {
                "code=\"\(code)\" and cacheId=\(cacheId) and end>=\"\(mindate)\" and begin<=\"\(maxdate)\""
            }, orderby: {
                "begin"
            }, limit: {
                nil
            }, offset: {
                nil
            })
        
        let index:Double = Double( dailys.firstIndex {
           return $0.date == cacheDate
        } ?? 0)
        
        kChartView.moveViewToX(index)
    }
    

    
    /// 样式
    func styleDataSet(dataSet:CandleChartDataSet) {
        dataSet.label = "\(code)"
        dataSet.decreasingColor = .green
        dataSet.decreasingFilled = true
        dataSet.increasingColor = .red
        dataSet.increasingFilled = true
        dataSet.shadowColorSameAsCandle = true
    }
  
    
   
    
    func candleChartDataSet(datylys:[Daily])->CandleChartDataSet{
        let entries =  datylys.enumerated().map { (index,item) in
           
            return CandleChartDataEntry(
                x:Double(index),
                shadowH: Double(item.high),
                shadowL: Double(item.low),
                open: Double(item.open),
                close: Double(item.close),
                data: item
            )
        }
        let dataset = CandleChartDataSet(entries: entries)
        styleDataSet(dataSet: dataset)

        return dataset
    }
    func amountDataSet(datylys:[Daily]) -> [BarChartDataSet] {
        var barColors:[NSUIColor] = []
        let entrys = dailys.enumerated().map { (index,item) -> BarChartDataEntry in
            let entry = BarChartDataEntry(x: Double(index), y: Double(item.amount/100000))
            barColors.append((item.open >= item.close) ? .green : .red)
            return entry
        }
        let dataSet = BarChartDataSet(entries: entrys, label: "amount")
        dataSet.axisDependency = .right;
        dataSet.colors = barColors
        dataSet.drawValuesEnabled = false
        return [dataSet]
    }
}

struct SFUIAnalyseChartsView: UIViewRepresentable {
    
    @ObservedObject var obser:SFUIAnalyseCharts
    
    func makeUIView(context: Context) -> AnalyseChartsView {

        return obser.chartView
    }
    
    func updateUIView(_ uiView: AnalyseChartsView, context: Context) {
        obser.updateChartView(chartView: uiView)

    }

}

struct SFUIAnalyseChartsView_Previews: PreviewProvider {
    static var previews: some View {
        SFUIAnalyseChartsView(obser: SFUIAnalyseCharts())
    }
}
