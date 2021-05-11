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



public class UGAnalyse :ObservableObject {
    
    @Published var code:String = "300022.sz" //股票代码
    @Published var begin:Date = Date()
    @Published var end:Date = Date()
    @Published public var analyse = Analyse()
    @Published public var point:[[String:NSObject]] = [[String:NSObject]]()
    public init() {}
    /*:
     获取策略详情
     */
    public func plotInfo() throws {
        print("plotInfo:\(analyse.name)")
        self.setup()
        let plot = Python.import("Analyse.\(analyse.name)")
        let infostr = "\(plot.info())"
        let data:Data = infostr.data(using: .utf8)!
        let tdata = try JSONDecoder().decode(Analyse.self, from: data)
        self.analyse = tdata
        
    }
    
    /*:
     获取策略参数
     */
    func plotparam() throws {
//        print("plotparam begin")
//        print("param:\(self.plot)")
//        var rparam:[String:String] = [:]
//        guard let params = self.plot.params else {
//            return
//        }
//        for item in params {
//            guard let titem = item? else {
//                return
//            }
//            rparam[titem.key] = titem.value
//        }
//        let tdata = try JSONEncoder().encode(rparam)
//        let str = String(data: tdata, encoding: .utf8)!
//        
//        let tplot = Python.import("Analyse.\(plot.name ?? "--")")
//        let points = tplot.analyse(code:self.code,
//                                   begin:self.begin.toString("yyyyMMdd"),
//                                   end:self.end.toString("yyyyMMdd"),
//                                   param:str)
//            .to_json(orient:"records")
//        
//        let jsondata = "\(points)".data(using: .utf8)!
//        let test = try JSONSerialization.jsonObject(with: jsondata, options: .mutableContainers)
//        self.point = test as! [[String : NSObject]]
//        print("plotparam end")
    }
    
    
    func setup() {
        let py_sys = Python.import("sys")
        py_sys.path.append("/Users/admin/Documents/github/UGFAFAFA/code/")
        print("Python Version: \(py_sys.version)")
    }
    
}





