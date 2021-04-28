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
    
    /*:
     exchange 交易所地址 ''所有  SSE上交所 SZSE 深交所 HKEY 港交所
     status 上市状态 L上市 D退市 P暂停上市
     */
    public static func stockBasic(exchange:String="",status:String="L") throws -> PythonObject{
        let key = "UGAnalyse.stockBasic"
        let datapath  = py_os.path.join(data_path,"base.csv")
        if UGAnalyse.needDownload(key){
            let pro = py_ts.pro_api()
            let data = pro.query("stock_basic")
            data.sort_index(inplace:true)
            
            data.to_csv(datapath)
            if let date = Date().toString("yyyy-MM-dd HH:mm:ss"){
                try DataCache.setvalue(date, for: key)
            }
            return data
        }else{
             
            return py_pd.read_csv(datapath)
        }
    }
}

extension UGAnalyse{
    
    public static func needDownload(_ key:String) -> Bool{
        /*:
         更新时间判断
         1: 上次下载时间晚于当今天16:00 return false
         2: 现在时间早于16:00 上次下载时间晚于昨天16:00 return false
         */
        let now = Date()
        let laseDownDate = try? DataCache.value(of: key)?.toDate()
        let tody16 = now.toString("yyyy-MM-dd")?.appending(" 16:00:00").toDate()
        let yestody16 = Date(timeInterval: -24*60*60, since: tody16!)
        // date1.compare(date2) == .orderedAscending date1 < date2
        if tody16!.compare(laseDownDate!) == .orderedAscending  {
            return false
        }else if now.compare(tody16!) == .orderedAscending && yestody16.compare(laseDownDate!) == .orderedAscending{
            return false
        }
        return true
        
    }
}




