//
//  Daily.swift
//  apple
//
//  Created by admin on 2021/7/2.
//

import Foundation
import Alamofire
import UGSwiftKit
import SQLite


public struct Daily:CRUDSqliteProtocol {

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
    public init(){
        code = "000000"
        date = "20210701"
        amount = Float(arc4random_uniform(100))*0.01
        open = Float(arc4random_uniform(100))*0.01
        close = Float(arc4random_uniform(100))*0.01
        low = Float(arc4random_uniform(100))*0.01
        high = Float(arc4random_uniform(100))*0.01
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let tcode = try container.decodeIfPresent(String.self, forKey: .code)
        code = tcode ?? ""
        let tdate = try container.decodeIfPresent(String.self, forKey: .date)
        date = tdate ?? ""
        let tamount = try container.decodeIfPresent(Float.self, forKey: .amount)
        let topen = try container.decodeIfPresent(Float.self, forKey: .open)
        let tclose = try container.decodeIfPresent(Float.self, forKey: .close)
        let tlow = try container.decodeIfPresent(Float.self, forKey: .low)
        let thigh = try container.decodeIfPresent(Float.self, forKey: .high)
        amount = tamount ?? 0
        open = topen ?? 0
        close = tclose ?? 0
        low = tlow ?? 0
        high = thigh ?? 0
    }
    

    
}
/// 数据请求与组装
public extension Daily{
    // 从服务器获取
    static func reqData(code:String, finesh:@escaping (BaseError?) ->  ()) {
        let url = "\(baseurl)/share/daily"
        let lastDate:String = Daily.last(code: code)?.date ?? "20130101"
        if lastDate == Date.init().toString("yyyyMMdd")  {
            finesh(nil)
        }
        let param = ["code":code,
                     "date": lastDate]
        
        AF.request(url, method: .get, parameters: param)
            .responseModel([Daily].self) { result in
                switch result{
                case .failure(let error):
                    print("\(url) \n \(param) \n \(error)")
                    finesh(.init(code: error.code, msg: error.msg))
                case .success(let value):
                    print(value)
                    do{
                        _ = try Daily.insert(datas: value, keys:Self.sqlKeys, model: .Replace)
                        finesh(nil)
                    }
                    catch {
                        finesh(.init(code: -1, msg: "db error \(error)"))
                    }
                    
                }
            }
    }
}

/// sql
extension Daily{
    
    static let sqlKeys = [
        ModelKey.init(column: "code", keypath: \Self.code),
        ModelKey.init(column: "date", keypath: \Self.date),
        ModelKey.init(column: "amount", keypath: \Self.amount),
        ModelKey.init(column: "open", keypath: \Self.open),
        ModelKey.init(column: "close", keypath: \Self.close),
        ModelKey.init(column: "low", keypath: \Self.low),
        ModelKey.init(column: "high", keypath: \Self.high),
    ]
    
    public static func tableName() -> String{
       
        let tableName = "\(Self.self)".lowercased()
        let sql = """
         CREATE TABLE IF NOT EXISTS "\(tableName)"(
            "code" TEXT,
            "date" TEXT,
            "amount" NUMERIC,
            "open" NUMERIC,
            "close" NUMERIC,
            "low" NUMERIC,
            "high" NUMERIC,
            PRIMARY KEY("code","date")
         )
         """
       _ = try! Self.sqliteCon().execute(sql)
        
        return tableName
    }
    
    static func last(code:String) -> Self?{
        let dailys = try! Self.select(keys: {
            Daily.sqlKeys
        }, fitter: {
            "code=\"\(code)\""
        }, orderby: {
            "date DESC"
        }, limit: {
            1
        }, offset: {
            0
        })
        return dailys.last
    }
    
 
}


