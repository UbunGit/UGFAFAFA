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

    func setup() {
        let py_sys = Python.import("sys")
        py_sys.path.append("/Users/admin/Documents/github/UGFAFAFA/code/")
        print("Python Version: \(py_sys.version)")
    }
    
}





