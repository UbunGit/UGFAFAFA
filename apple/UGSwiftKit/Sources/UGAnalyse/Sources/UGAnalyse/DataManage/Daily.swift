//
//  File.swift
//  日线数据
//
//  Created by admin on 2021/4/29.
//

import Foundation
import PythonKit

struct Daily {
    
}

extension Daily :DataManageProtocol{
    /*:
     更新日线数据
     code 股票编码
     start 开始日期(YYYYMMDD)
     end 结束日期(YYYYMMDD)
     */
    public static func update(_ code:String, start:String? = nil,end:String? = nil) throws -> PythonObject{
        let py_os =  Python.import("os")
        let py_ts = Python.import("tushare")
        let py_pd = Python.import("pandas")
        let cachekey = "UGAnalyse.Daily.\(code)"
        let datapath  = py_os.path.join(data_path,"tushare/\(code).csv")
        if StockBasic.needDownload(cachekey){
            let pro = py_ts.pro_api()
            var data = pro.query("daily",ts_code:code, start_date:start, end_date:end)
            data.sort_index(inplace:true)
            data = data.rename(columns:["trade_date":"date"])
            data.to_csv(datapath)
            if let date = Date().toString("yyyy-MM-dd HH:mm:ss"){
                try DataCache.setvalue(date, for: cachekey)
            }
            return data
        }else{
             
            return py_pd.read_csv(datapath)
        }
    }
}
