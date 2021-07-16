//
//  ETFBase+db.swift
//  apple
//
//  Created by admin on 2021/7/15.
//

import Foundation
extension ETFBasic:CRUDSqliteProtocol{

    public static var sqlKeys = [
        ModelKey.init(column: "name", keypath: \Self.name),
        ModelKey.init(column: "code", keypath: \Self.code),
        ModelKey.init(column: "changeTime", keypath: \Self.changeTime),
        
    ]
    
    public static func tableName() -> String{
       
        let tableName = "\(Self.self)".lowercased()
        let sql = """
         CREATE TABLE IF NOT EXISTS "\(tableName)"(
            "name" TEXT,
            "code" TEXT,
            "changeTime" TEXT,
            PRIMARY KEY("code")
         )
         """
       _ = try! Self.sqliteCon().execute(sql)
        
        return tableName
    }
}
