//
//  File.swift
//  股票列表
//
//  Created by admin on 2021/4/29.
//

import Foundation
import PythonKit

struct StockBasic:DataManageProtocol {
    /*:
     # 更新股票列表
     exchange 交易所地址 ''所有  SSE上交所 SZSE 深交所 HKEY 港交所
     status 上市状态 L上市 D退市 P暂停上市
     */
    public static func update(exchange:String="",status:String="L") throws -> PythonObject{
        let key = "UGAnalyse.stockBasic"
        let datapath  = py_os.path.join(data_path,"base.csv")
        if StockBasic.needDownload(key){
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

