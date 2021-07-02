//
//  InsterProtocol.swift
//  apple
//
//  Created by admin on 2021/4/22.
//

import Foundation

public protocol SqliteInsterProtocol:SqliteProtocol{
  
    func insert() throws -> Int?
    
    static func insert(datas: [Self]) throws -> Int?

}

extension SqliteInsterProtocol{
    
    func insert() throws -> Int? {
        return 0
    }
    
    static func insert(datas: [Self]) throws -> Int?{
        for item in datas{
            let tmt = "INSERT INTO \(item.tableName) (email) VALUES (?)"
            print(tmt)
//            let stmt = try item.sqliteCon?.prepare("INSERT INTO \(type(of: item)) (email) VALUES (?)")
        }
//        datas.forEach { item in
////            let stmt = try sqliteCon?.prepare("INSERT INTO users (email) VALUES (?)")
//        }
        return 0
    }
    
}






