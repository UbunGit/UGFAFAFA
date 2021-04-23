//
//  Moden.swift
//  apple
//
//  Created by admin on 2021/4/21.
//

import Foundation
import PerfectSQLite
import PerfectCRUD

public typealias CRUDSqliteProtocol = SqliteProtocol & SqliteDeleteProtocol & SqlitInsterProtocol


public protocol SqliteProtocol:Codable{
    /**
     数据库地址
     */
    static var sqlite:Database<SQLiteDatabaseConfiguration>{get}
}

extension SqliteProtocol{
    
    static var sqlite:Database<SQLiteDatabaseConfiguration> {
        get{
            
            let dbPath = UserDefaults.standard.string(forKey: "dbfile") ?? "" + "share.db"
            return Database(configuration: try! SQLiteDatabaseConfiguration(dbPath))
        }
    }
}


// MARK: DELETE
public protocol SqliteDeleteProtocol:SqliteProtocol{
    /**
     删除
     */
    static func delete(_ exp:CRUDBooleanExpression) throws;
 
}

extension SqliteDeleteProtocol{

    
    static func delete(_ exp:CRUDBooleanExpression) throws{
        do {
//            let db = Database(configuration: try! SQLiteDatabaseConfiguration(dbfile))
            try sqlite.table(Self.self)
                .where(exp)
                .delete()
        }catch{
            throw APIError(code: -1, msg: "数据库操作失败")
        }
    }
}




