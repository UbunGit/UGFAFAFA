import Foundation
import PythonKit

public var data_path = "./"
public let analyse_db = "\(data_path)sqlite/analyse.db"


public struct UGAnalyse {
    
    var text = "Hello, World!"

}

extension UGAnalyse{
    /*:
     初始化
     */
    public static func setup(
        locallib:String = "/Users/admin/Documents/github/UGFAFAFA/code/",
        datapath:String = "/Users/admin/Documents/GitHub/UGFAFAFA/data/"
        ){
        PythonLibrary.useVersion(3)
        print("UGAnalyse setup")
        let py_sys = Python.import("sys")
//        print("Python Version: \(py_sys.version)")
        py_sys.path.append(locallib)
        data_path = datapath
  
        let py_ts = Python.import("tushare")
        py_ts.set_token("8631d6ca5dccdcd4b9e0eed7286611e40507c7eba04649c0eee71195")
    }
}






