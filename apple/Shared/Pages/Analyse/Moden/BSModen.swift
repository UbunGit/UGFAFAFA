//
//  BSModen.swift
//  apple
//  BS记录
//  Created by admin on 2021/7/8.
//

import Foundation
import SQLite
import Alamofire
import UGSwiftKit

struct AnalyseDetails:Codable {
    
    var bsRecord:[BSModen]
    var zone:[ZoneModen]
    
    static func reqData(code:String, cacheId:Int, finesh:@escaping (BaseError?) ->  ()){
        if  BSModen.last(id: cacheId) != nil {
            return
        }
        let url = "\(baseurl)/analyses/history/Details"
        let param = ["code":code,
                     "cacheId": "\(cacheId)"]
        
        AF.request(url, method: .get, parameters: param)
            .responseModel(AnalyseDetails.self) { result in
                switch result{
                case .failure(let error):
                    print("\(url) \n \(param) \n \(error)")
                    finesh(.init(code: error.code, msg: error.msg))
                case .success(let value):
                    print("\(url) \n \(param) \n \(value)")
                    do{
                        _ = try BSModen.insert(datas: value.bsRecord, keys:BSModen.sqlKeys, model: .Replace)
                        _ = try ZoneModen.insert(datas: value.zone, keys: ZoneModen.sqlKeys, model: .Replace)
                        finesh(nil)
                    }
                    catch {
                        finesh(.init(code: -1, msg: "db error \(error)"))
                    }
                    
                }
            }
    }
}

struct BSModen {
    
    var id:Double
    var cacheId:Int
    var date:String
    var code:String
    var count:Int
    var price:Double
    var free:Double
    var type:Int // 1买入 2 卖出
    
  
    public init(){
        id = 0
        code = ""
        date = ""
        cacheId = 0
        count = 0
        price = 0
        free = 0
        type = 0
    }
    
    public init(from decoder: Decoder) throws {
        do{
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let tid = try container.decodeIfPresent(Double.self, forKey: .id)
            let tcode = try container.decodeIfPresent(String.self, forKey: .code)
            let tdate = try container.decodeIfPresent(String.self, forKey: .date)
            let tcacheId = try container.decodeIfPresent(Int.self, forKey: .cacheId)
            let tcount = try container.decodeIfPresent(Int.self, forKey: .count)
            let tprice = try container.decodeIfPresent(Double.self, forKey: .price)
            let tfree = try container.decodeIfPresent(Double.self, forKey: .free)
            let ttype = try container.decodeIfPresent(Int.self, forKey: .type)
            id = tid ?? 0
            code = tcode ?? ""
            date = tdate ?? ""
            cacheId = tcacheId ?? 0
            count = tcount ?? 0
            price = tprice ?? 0
            free = tfree ?? 0
            type = ttype ?? 0
        }catch{
            print("\(error)")
            id =  0
            code = ""
            date = ""
            cacheId =  0
            count =  0
            price = 0
            free =  0
            type =  0
            
        }
      
    }

}


extension BSModen: CRUDSqliteProtocol{
    
    static var sqlKeys = [
        ModelKey.init(column: "id", keypath: \Self.id),
        ModelKey.init(column: "code", keypath: \Self.code),
        ModelKey.init(column: "date", keypath: \Self.date),
        ModelKey.init(column: "cacheId", keypath: \Self.cacheId),
        ModelKey.init(column: "count", keypath: \Self.count),
        ModelKey.init(column: "price", keypath: \Self.price),
        ModelKey.init(column: "free", keypath: \Self.free),
        ModelKey.init(column: "type", keypath: \Self.type),
    ]
    
    public static func tableName() -> String{
       
        let tableName = "\(Self.self)".lowercased()
        let sql = """
         CREATE TABLE IF NOT EXISTS "\(tableName)"(
            "id" INTEGER,
            "code" TEXT,
            "date" TEXT,
            "cacheId" INTEGER,
            "count" INTEGER,
            "price" NUMERIC,
            "free" NUMERIC,
            "type" INTEGER,
            PRIMARY KEY("id")
         )
         """
       _ = try! Self.sqliteCon().execute(sql)
        
        return tableName
    }
    
    static func last(id:Int) -> Self?{
        let dailys = try? Self.select(fitter: {
            "id=\(id)"
        }, orderby: {
            "id"
        }, limit: {
            1
        }, offset: {
            0
        })
   
        return dailys?.last
    }
}
