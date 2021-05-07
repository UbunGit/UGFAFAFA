//
//  File.swift
//  
//
//  Created by admin on 2021/4/29.
//

import Foundation
import PythonKit
import SwiftUI

public  let version = "1.0.0"

public struct Plot:Codable{
    
    public var name:String = ""
    public var des:String = ""
    public var params:[Param] = []
    
    public struct Param:Codable{
        public var key:String = ""
        public var des:String = ""
        public var value:String = ""
    }
    
    
}

public class UGAnalyse :ObservableObject {
    
    @State var code:String = "300022.sz" //股票代码
    @State var begin:Date = Date()
    @State var end:Date = Date()
    @Published public var plot = Plot()
    @Published public var point:[[String:NSObject]] = [[String:NSObject]]()
    public init() {}
    /*:
     获取策略详情
     */
    public func plotInfo() throws {
        print("plotInfo:\(plot.name)")
        self.setup()
        let plot = Python.import("Analyse.\(plot.name)")
        let infostr = "\(plot.info())"
        let data:Data = infostr.data(using: .utf8)!
        let tdata = try JSONDecoder().decode(Plot.self, from: data)
        self.plot = tdata
        
    }
    
    /*:
     获取策略参数
     */
    func plotparam() throws {
        print("plotparam begin")
        print("param:\(self.plot)")
        var rparam:[String:String] = [:]
        for item in self.plot.params {
            rparam[item.key] = item.value
        }
        let tdata = try JSONEncoder().encode(rparam)
        let str = String(data: tdata, encoding: .utf8)!
        
        let tplot = Python.import("Analyse.\(plot.name)")
        let points = tplot.analyse(code:self.code,
                                   begin:self.begin.toString("yyyyMMdd"),
                                   end:self.end.toString("yyyyMMdd"),
                                   param:str)
            .to_json(orient:"records")
        
        let jsondata = "\(points)".data(using: .utf8)!
        let test = try JSONSerialization.jsonObject(with: jsondata, options: .mutableContainers)
        self.point = test as! [[String : NSObject]]
        print("plotparam end")
    }
    
    
    func setup() {
        let py_sys = Python.import("sys")
        py_sys.path.append("/Users/admin/Documents/github/UGFAFAFA/code/")
        print("Python Version: \(py_sys.version)")
    }
    
}

let _tplot = Plot(name: "maline", des: "Maline", params: [
    Plot.Param(key: "ma1", des: "ma1", value: "5"),
    Plot.Param(key: "ma2", des: "ma2", value: "30")
])



