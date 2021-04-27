//
//  PythonManage.swift
//  apple (iOS)
//
//  Created by admin on 2021/3/29.
//

import Foundation
import PythonKit

let pysys =  Python.import("sys")
let pyos =  Python.import("os")
let codepath = "/Users/admin/Documents/github/UGFAFAFA/code"
// pandas
let py_pands = Python.import("pandas")

public func py_setup(){
    pysys.path.append(codepath)
}





 
