//
//  Notification.swift
//  apple
//
//  Created by admin on 2021/7/15.
//

import Foundation
import Alamofire
import UGSwiftKit

public extension NSNotification{
    static let nf_updatelist = Notification.Name.init("updatelist")
}

// 更新股票数据库
public func updateStockBase(finesh:@escaping ((BaseError?) ->  ())) {
    
    let enddate:String = StockBasic.last(column: "changeTime", isDesc: true)?.changeTime ?? ""
    AF.api_store_basic(changeTime: enddate) { result in
        switch result{
        case .failure(let error):
            print(error)
            finesh(BaseError.init(code: -1, msg: error.msg))
        case .success(let value):
            try? StockBasic.insert(datas: value,model:.Replace)
            finesh(nil)
        }
    }
}

// 更新etf数据库
public func updateETFBase(finesh:@escaping ((BaseError?) ->  ())) {
    
    let enddate:String = ETFBasic.last(column: "changeTime", isDesc: true)?.changeTime ?? ""
    AF.api_etf_basic(changeTime: enddate) { result in
        switch result{
        case .failure(let error):
            print(error)
            finesh(BaseError.init(code: -1, msg: error.msg))
        case .success(let value):
            try? ETFBasic.insert(datas: value,model:.Replace)
            finesh(nil)
        }
    }
}






