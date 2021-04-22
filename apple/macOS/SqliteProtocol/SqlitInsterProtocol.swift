//
//  InsterProtocol.swift
//  apple
//
//  Created by admin on 2021/4/22.
//

import Foundation
import PerfectSQLite
import PerfectCRUD
public protocol SqlitInsterProtocol:SqliteProtocol{
  
    func insert() throws -> Int?


    func insert<Z: Decodable>( setKeys: KeyPath<Self, Z>, _ rest: PartialKeyPath<Self>...) throws -> Int?


    func insert<Z: Decodable>( ignoreKeys: KeyPath<Self, Z>) throws -> Int
    
}

extension SqlitInsterProtocol{
    
    func insert() throws -> Int?{
        do {
            let db = Database(configuration: try! SQLiteDatabaseConfiguration(Self.dbfile))
            return try db.table(Self.self)
                .insert(self)
                .lastInsertId()
        }catch{
            throw APIError(code: -1, msg: "数据库操作失败")
        }
    }
    
    func insert<Z: Decodable>( setKeys: KeyPath<Self, Z>, _ rest: PartialKeyPath<Self>...) throws -> Int?{
       
        do {
            let db = Database(configuration: try! SQLiteDatabaseConfiguration(Self.dbfile))
            guard let id = try db.table(Self.self)
                    .insert(self,setKeys:setKeys)
                    .lastInsertId() else{
                throw APIError(code: -1, msg: "数据库操作失败")
            }
            return id
        }catch{
            throw APIError(code: -1, msg: "数据库操作失败")
        }
    }
    func insert<Z: Decodable>( ignoreKeys: KeyPath<Self, Z>) throws -> Int{
        do {
            let db = Database(configuration: try! SQLiteDatabaseConfiguration(Self.dbfile))
            guard let id = try db.table(Self.self)
                    .insert(self,ignoreKeys:ignoreKeys)
                    .lastInsertId() else{
                throw APIError(code: -1, msg: "数据库操作失败")
            }
            return id
            
            
        }catch{
            throw APIError(code: -1, msg: "数据库操作失败")
        }
    }
}
