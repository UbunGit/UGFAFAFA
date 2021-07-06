//
//  InsterProtocol.swift
//  apple
//
//  Created by admin on 2021/4/22.
//

import Foundation

public enum CRUDInsertModel:String {
    case None = "" // 直接插入
    case Replace = "OR REPLACE" // 替换
    case Ignore = "OR IGNORE" // 忽略
}

public protocol SqliteInsterProtocol:SqliteProtocol{

    
    static func insert(datas: [Self], keys:[ModelKey], model:CRUDInsertModel) throws

}

public extension SqliteInsterProtocol{
   
    static func insert(datas: [Self], keys:[ModelKey], model:CRUDInsertModel = .None) throws {
        if datas.count<=0 {
            return
        }
        let str = keys.map { key in
            return key.column
        }.joined(separator: ",")
        
        var sql = "INSERT \(model.rawValue) INTO \(Self.tableName()) (\(str)) VALUES "
        let values = datas.map { item in
            
            let value = keys.map { key -> String in
                getKeypathValue(item, keyPath: key.keypath) ?? ""
               
            }.joined(separator: ",")
            return "(\(value))"
            
        }.joined(separator: ",")
        sql.append(values)
        print(sql)
        try Self.sqliteCon().execute(sql)

    }
    
}








