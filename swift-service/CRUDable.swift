//
//  File.swift
//  
//
//  Created by admin on 2021/4/28.
//
import Foundation
import PerfectSQLite
import PerfectCRUD

public protocol CRUDable{
    
    associatedtype T:CodableIdentifiable
    
    static var dbfile:String { get }


}
extension CRUDable{
    
    public static func sqlite() throws -> Database<SQLiteDatabaseConfiguration>{
        
        let db = Database(configuration: try SQLiteDatabaseConfiguration(Self.dbfile))
        try db.create(T.self,primaryKey: \T.id, policy: .reconcileTable)
        return db
    }
    
    public static func table() throws -> Table<T, Database<SQLiteDatabaseConfiguration>> {
        return try sqlite().table(T.self)
    }
}

