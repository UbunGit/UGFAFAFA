//
//  SqliteSelectProtocol.swift
//  apple (iOS)
//
//  Created by admin on 2021/7/2.
//

import Foundation

// MARK: DELETE
public protocol SqliteSelectProtocol:SqliteProtocol{
    
    static func last() -> Self?
    
    static func select(
        keys:()->[ModelKey],
        fitter:() -> (String?),
        orderby:() -> (String?),
        limit:() -> (Int?),
        offset:()->(Int?)
    ) throws -> [Self]
}

public extension SqliteSelectProtocol{
    
    static func last() -> Self?{
        return nil
    }
    
    static func select(
        keys:()->[ModelKey],
        fitter:() -> (String?),
        orderby:() -> (String?),
        limit:() -> (Int?),
        offset:()->(Int?)
    ) throws -> [Self]{
        
        let str = keys().map { key in
            return key.column
        }.joined(separator: ",")
        
        var sql = "select \(str) from \(Self.tableName())"
        if let sfitter = fitter() {
            sql.append(" where \(sfitter) ")
        }
        if let sorderby = orderby() {
            sql.append(" order by \(sorderby) ")
        }
        if let slimmit = limit() {
            sql.append(" limit \(slimmit) ")
        }
        if let soffset = offset() {
            sql.append(" offset \(soffset) ")
        }
        print(sql)
        let stmt = try Self.sqliteCon().prepare(sql)

        let result = try stmt.map { row->Self in
           
            var item:Dictionary = [String:Any]()
            for (index, name) in stmt.columnNames.enumerated() {
                item[name] = row[index]!
            }
            return try JSONDecoder.init().decode(Self.self, from: item) 
        }
       
        return result
    }
}
