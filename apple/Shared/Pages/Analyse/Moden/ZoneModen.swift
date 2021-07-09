//
//  ZoneModen.swift
//  apple
//
//  Created by admin on 2021/7/9.
//

import Foundation
import SQLite
import Alamofire
import UGSwiftKit

struct ZoneModen:CRUDSqliteProtocol {
    
    var id:Double
    var cacheId:Int
    var code:String
    var begin:String
    var end:String
    var earnings:Double
    var earningsV:Double
    
    public init(){
        id = 0
        code = ""
        cacheId = 0
        begin = ""
        end = ""
        earnings = 0
        earningsV = 0
    }
    
    public init(from decoder: Decoder) throws {
        do{
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let tid = try container.decodeIfPresent(Double.self, forKey: .id)
            let tcode = try container.decodeIfPresent(String.self, forKey: .code)
            let tcacheId = try container.decodeIfPresent(Int.self, forKey: .cacheId)
            let tbegin = try container.decodeIfPresent(String.self, forKey: .begin)
            let tend = try container.decodeIfPresent(String.self, forKey: .end)
         
            let tearnings = try container.decodeIfPresent(Double.self, forKey: .earnings)
            let tearningsV = try container.decodeIfPresent(Double.self, forKey: .earningsV)
            
            id = tid ?? 0
            code = tcode ?? ""
            cacheId = tcacheId ?? 0
            begin = tbegin ?? ""
            end = tend ?? ""
            earnings = tearnings ?? 0
            earningsV = tearningsV ?? 0
        
        }catch{
            print("\(error)")
            id =  0
            code = ""
            begin = ""
            cacheId =  0
            end = ""
            earnings = 0
            earningsV =  0
      
            
        }
      
    }

}

extension ZoneModen{
    
    static let sqlKeys = [
        ModelKey.init(column: "id", keypath: \Self.id),
        ModelKey.init(column: "code", keypath: \Self.code),
        ModelKey.init(column: "cacheId", keypath: \Self.cacheId),
        ModelKey.init(column: "begin", keypath: \Self.begin),
        ModelKey.init(column: "end", keypath: \Self.end),
        ModelKey.init(column: "earnings", keypath: \Self.earnings),
        ModelKey.init(column: "earningsV", keypath: \Self.earningsV),
    
    ]
    
    public static func tableName() -> String{
       
        let tableName = "\(Self.self)".lowercased()
        let sql = """
         CREATE TABLE IF NOT EXISTS "\(tableName)"(
            "id" INTEGER,
            "code" TEXT,
            "cacheId" INTEGER,
            "begin" TEXT,
            "end" TEXT,
            "earnings" NUMERIC,
            "earningsV" NUMERIC,
            PRIMARY KEY("id")
         )
         """
       _ = try! Self.sqliteCon().execute(sql)
        
        return tableName
    }
    
    static func last(id:Int) -> Self?{
        let dailys = try! Self.select(keys: {
            BSModen.sqlKeys
        }, fitter: {
            "id=\(id)"
        }, orderby: {
            "id"
        }, limit: {
            1
        }, offset: {
            0
        })
        return dailys.last
    }
}
