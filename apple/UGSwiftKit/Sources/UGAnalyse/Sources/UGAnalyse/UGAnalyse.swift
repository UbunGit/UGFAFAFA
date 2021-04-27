
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
        locallib:String = "/Users/admin/Documents/github/UGFAFAFA/code",
        datapath:String = "/Users/admin/Documents/GitHub/UGFAFAFA/data"
        ){

        print("UGAnalyse setup")
        py_sys.path.append(locallib)
        data_path = datapath
        print("\(py_sys.path)")
        py_ts.set_token("8631d6ca5dccdcd4b9e0eed7286611e40507c7eba04649c0eee71195")
    }
    
    /*:
     exchange 交易所地址 ''所有  SSE上交所 SZSE 深交所 HKEY 港交所
     status 上市状态 L上市 D退市 P暂停上市
     */
    public static func stockBasic(exchange:String="",status:String="L") throws -> PythonObject{
        
        let pro = py_ts.pro_api()
        let data = pro.query("stock_basic")
        data.rename(columns:["trade_date":"date"])
        data.sort_index(inplace:true)
        let savpath  = py_os.path.join(data_path,"base.csv")
        data.to_csv(savpath)
        return data
    }
}


