//
//  File.swift
//  
//
//  Created by admin on 2021/4/29.
//

import Foundation
import PythonKit

public struct UGMAAnalyse{
    
    /*:
     分析均线
     */
    public static func analyse() throws {
       
        
        // 0 获取数据
        var data = try Daily.update("000001.SZ")
       
        data = data.sort_values(by:"date",ignore_index:true)
 
        // 1 计算所需数据
        // macd
        try Talib.macd(data: data)
        try Talib.ma(data, times:[5,30])
        data["ma5_1"] = data["ma5"].shift(-1)
        data["ma30_1"] = data["ma30"].shift(-1)
        try Talib.shiftv(data, times: [5,10,15,30,50])
        
        let datapath  = py_os.path.join(data_path,"analyse/base.csv")
        data.to_csv(datapath)
        
        let ndata = data.dropna(axis:0, how:"any")
        let tdata = ndata.iloc.filter {
            return LineLib.states(line1: LineLib.Line(begin: $0.ma5_1, end: $0.ma5), line2: LineLib.Line(begin: $0.ma30_1, end: $0.ma30)) == .upintersect
        }
        var datas = [PythonObject]()
        var times = [String]()
        
        for item in data.iloc {
            datas.append([item.open,item.close,item.low,item.high])
            times.append("\(item.date)")
        }
        var points =  [[String: PythonObject]]()
        for item in tdata {
            
            points.append([
                "name": PythonObject("\(item.date)"),
                "value":item.close,
                "coord": [PythonObject("\(item.date)"), item.close],
            ])
        }
        
        let kline = Kline(xaxis: times, y_axis: datas, points: points)
        kline.draw()

    }

    

    
}

