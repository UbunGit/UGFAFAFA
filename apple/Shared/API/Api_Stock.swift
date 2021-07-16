//
//  Api_Stock.swift
//  apple
//
//  Created by admin on 2021/7/12.
//

import Foundation
import Alamofire
import UGSwiftKit

public extension Session{
    
    // A股 股票列表数据
    func api_store_basic(changeTime:String, finesh:@escaping (Result<[StockBasic], APIError>) ->  ()){
        
        let url = "\(baseurl)/store/basic"
        let param = ["changeTime":changeTime]
        AF.request(url, method: .get, parameters: param){ urlRequest in
            urlRequest.timeoutInterval = 5
        }.responseModel([StockBasic].self, callback: finesh)
        
    }
    
    // etf 列表数据
    func api_etf_basic(changeTime:String, finesh:@escaping (Result<[ETFBasic], APIError>) ->  ()){
        let url = "\(baseurl)/etf/basic"
        let param = ["changeTime":changeTime]
        AF.request(url, method: .get, parameters: param){ urlRequest in
            urlRequest.timeoutInterval = 5
        }.responseModel([ETFBasic].self, callback: finesh)
        
    }
    
}


