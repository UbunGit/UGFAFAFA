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
    func api_store_basic(finesh:@escaping (Result<[StockBasic], APIError>) ->  ()){
        
        let url = "\(baseurl)/base"
        AF.request(url, method: .get, parameters: nil){ urlRequest in
            urlRequest.timeoutInterval = 5
        }.responseModel([StockBasic].self, callback: finesh)
        
    }
    
}


