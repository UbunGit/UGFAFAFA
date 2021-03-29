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

func confitpython()  {
//    = ["Python.framework/Versions/:/Python"]
    PythonLibrary.useLibrary(at: "Python.framework/Versions/3.8/Python")
//    PythonLibrary.useVersion(3,9)
    print("Python \(pysys.version_info.major).\(pysys.version_info.minor)")
    print("Python Version: \(pysys.version)")
    let codepath = "/Users/admin/Documents/github/UGFAFAFA/code"
    pysys.path.append(codepath)
    


}

func pythonManageTest1()  {
    
    let webser =  Python.import("code")
    webser.start()
    

}

