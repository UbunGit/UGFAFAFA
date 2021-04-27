
import PythonKit


public let py_sys = Python.import("sys")
public let py_os =  Python.import("os")
public let py_pd = Python.import("pandas")
public let py_ts = Python.import("tushare")


public struct SAnalyse {
    
    var text = "Hello, World!"
   

}

extension SAnalyse{
    /*:
     
     初始化
     */
    public static func setup(locallib:String = "/Users/admin/Documents/github/UGFAFAFA/code"){
       ///System/Library/Frameworks/Python.framework/Versions/2.7/lib/python27.zip', '/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7'
//        PythonLibrary.useLibrary(at: "/Library/Frameworks/Python.framework")
//        PythonLibrary.useVersion(3)
        print("SAnalyse setup")
        py_sys.path.append(locallib)
        print("\(py_sys.path)")
        py_ts.set_token("8631d6ca5dccdcd4b9e0eed7286611e40507c7eba04649c0eee71195")
    }
    
    /*:
     exchange 交易所地址 ''所有  SSE上交所 SZSE 深交所 HKEY 港交所
     status 上市状态 L上市 D退市 P暂停上市
     */
   
    public static func stockBasic(exchange:String="",status:String="L"){
        let data = try? py_ts.query("stock_basic")
        print(data)
    }
}


