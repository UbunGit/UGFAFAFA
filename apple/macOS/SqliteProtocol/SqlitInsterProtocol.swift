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

    func insert<Z: Decodable>( ignoreKeys: KeyPath<Self, Z>,_ rest: PartialKeyPath<Self>...) throws -> Int
    
}

extension SqlitInsterProtocol{
    
    func insert() throws -> Int?{
        do {
            return try Self.sqlite.table(Self.self)
                .insert(self)
                .lastInsertId()
        }catch{
            throw APIError(code: -1, msg: "数据库操作失败")
        }
    }
    
    func insert<Z: Decodable>( setKeys: KeyPath<Self, Z>, _ rest: PartialKeyPath<Self>...) throws -> Int?{
        do {
            guard let id = try Self.sqlite.table(Self.self)
                    .insert(self,setKeys:setKeys)
                    .lastInsertId() else{
                throw APIError(code: -1, msg: "数据库操作失败")
            }
            return id
        }catch{
            throw APIError(code: -1, msg: "数据库操作失败")
        }
    }
    
    func insert<Z: Decodable>( ignoreKeys: KeyPath<Self, Z>, _ rest: PartialKeyPath<Self>...) throws -> Int{
        do {
            guard let id = try Self.sqlite.table(Self.self)
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






