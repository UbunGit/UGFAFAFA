//
//  InsterProtocol.swift
//  apple
//
//  Created by admin on 2021/4/22.
//

import Foundation

public protocol SqliteInsterProtocol:SqliteProtocol{
  
    func insert() throws -> Int?
    
    static func insert(datas: [Self], setKeys:[ModelKey]) throws -> Int?

}

public extension SqliteInsterProtocol{
 
    func insert() throws -> Int? {
        return 0
    }
    static func insert(datas: [Self], setKeys:[ModelKey]) throws -> Int?{
        if datas.count<=0 {
            return 0
        }
        let str = setKeys.map { key in
            return key.column
        }.joined(separator: ",")
        
        var sql = "INSERT OR REPLACE INTO \(Self.tableName()) (\(str)) VALUES "
        let values = datas.map { item in
            
            let value = setKeys.map { key -> String in
                getKeypathValue(item, keyPath: key.keypath) ?? ""
               
            }.joined(separator: ",")
            return "(\(value))"
            
        }.joined(separator: ",")
        sql.append(values)
            
     

        let stmt = try Self.sqliteCon().execute(sql)

        return 0
    }
    
}








