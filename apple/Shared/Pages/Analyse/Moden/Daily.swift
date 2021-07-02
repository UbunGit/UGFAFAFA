//
//  Daily.swift
//  apple
//
//  Created by admin on 2021/7/2.
//

import Foundation
import Alamofire
import UGSwiftKit

struct Daily:CRUDSqliteProtocol {

    
    var code:String
    var date:String
    var amount:Float
    var open:Float
    var close:Float
    var low:Float
    var high:Float
    
    enum CodingKeys: String, CodingKey {
        case code
        case date
        case amount
        case open
        case close
        case low
        case high
  
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let tcode = try container.decodeIfPresent(String.self, forKey: .code)
        code = tcode ?? ""
        let tdate = try container.decodeIfPresent(String.self, forKey: .date)
        date = tdate ?? ""
        amount = try container.decodeIfPresent(Float.self, forKey: .amount) ?? 0
        open = try container.decodeIfPresent(Float.self, forKey: .open) ?? 0
        close = try container.decodeIfPresent(Float.self, forKey: .close) ?? 0
        low = try container.decodeIfPresent(Float.self, forKey: .low) ?? 0
        high = try container.decodeIfPresent(Float.self, forKey: .high) ?? 0
    }
    
    
}
/// 数据请求与组装
extension Daily{
    // 从服务器获取
    static func reqData(code:String, finesh:@escaping (BaseError) ->  ()) {
        let url = "\(baseurl)/share/daily"
        let lastDate:String = Daily.last()?.date ?? "20210620"
        let param = ["code":code,
                     "date": lastDate]
     
        AF.request(url, method: .get, parameters: param)
            .responseModel([Daily].self) { result in
                switch result{
                case .failure(let error):
                    finesh(.init(code: error.code, msg: error.msg))
                case .success(let value):
                    
                    _ = try? Daily.insert(datas: value)
                }
            }
   
    }
  
    
    static func dbData(code:String, finesh:@escaping (Result<[Daily], BaseError>) ->()){
        finesh(.success([]))
    }
    
}
