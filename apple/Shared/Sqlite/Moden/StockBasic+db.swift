//
//  StockBasic+db.swift
//  apple
//
//  Created by admin on 2021/7/12.
//

import Foundation
import SQLite

extension StockBasic:CRUDSqliteProtocol{

    static let sqlKeys = [
        ModelKey.init(column: "name", keypath: \Self.name),
        ModelKey.init(column: "code", keypath: \Self.code),
        ModelKey.init(column: "area", keypath: \Self.area),
        ModelKey.init(column: "industry", keypath: \Self.industry),
        ModelKey.init(column: "market", keypath: \Self.market),
    ]
    
    public static func tableName() -> String{
       
        let tableName = "\(Self.self)".lowercased()
        let sql = """
         CREATE TABLE IF NOT EXISTS "\(tableName)"(
            "name" TEXT,
            "code" TEXT,
            "area" NUMERIC,
            "industry" TEXT,
            "market" TEXT,
            PRIMARY KEY("code")
         )
         """
       _ = try! Self.sqliteCon().execute(sql)
        
        return tableName
    }
}
