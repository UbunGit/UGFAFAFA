import Foundation
import PythonKit

public let py_sys = Python.import("sys")
public let py_os =  Python.import("os")
public let py_pd = Python.import("pandas")
public let py_ts = Python.import("tushare")
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

        print("UGAnalyse setup")
        py_sys.path.append(locallib)
        data_path = datapath
        print("\(py_sys.path)")
        py_ts.set_token("8631d6ca5dccdcd4b9e0eed7286611e40507c7eba04649c0eee71195")
    }
    
 
}






