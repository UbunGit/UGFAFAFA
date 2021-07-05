//
//  Moden.swift
//  apple
//
//  Created by admin on 2021/4/21.
//

import Foundation
import SQLite
import UGSwiftKit

public typealias CRUDSqliteProtocol = SqliteProtocol & SqliteDeleteProtocol & SqliteInsterProtocol & SqliteSelectProtocol


public protocol SqliteProtocol:Codable{

    static func sqlitePath() -> String
    static func sqliteFile() -> String
    static func sqliteCon() -> Connection
    static func tableName() -> String
    
 
}

extension SqliteProtocol{

    
    public static func sqlitePath() -> String{
        let sqlitePath = UserDefaults.standard.string(forKey: "dbfile") ?? "\(KDocumnetPath)/sqlite"
        let manager = FileManager.default
   
     
        let exist = manager.fileExists(atPath: sqlitePath)
        if !exist {
            try! manager.createDirectory(at: URL(fileURLWithPath: sqlitePath), withIntermediateDirectories: true,
                                         attributes: nil)
        }
        return  sqlitePath
    }
    
    public static func sqliteFile() -> String{
        let sqllitefile = UserDefaults.standard.string(forKey: "dbfile") ?? "\(sqlitePath())/sqlite.db"
        print("sqllitefile:\(sqllitefile)")
        return  sqllitefile
    }
    public static func sqliteCon() -> Connection{
        
        return try! Connection(Self.sqliteFile())
    }
    public static func tableName() -> String{
        let  id = Expression<Int64>.init("uId")
        let tableName = "\(Self.self)".lowercased()
        let table = Table.init(tableName)
        try! sqliteCon().run(table.create(temporary: false, ifNotExists: true,withoutRowid: false, block: { builder in
            //设置主键和自增
            builder.column(id,primaryKey: .autoincrement)
         
        }))
        return tableName
    }

    static func getKeypathValue(_ instance: Any, keyPath: AnyKeyPath) -> String? {
        guard let v = instance[keyPath: keyPath] else {
            return nil
        }
        return Self.getKeyPathName(fromValue: v)
    }
    
    private static func getKeyPathName(fromValue v: Any)   -> String {
        
        switch v {
       
        case let s as String:
           
            return "\"\(s)\""
       
        default:
            return "\(v)"
         
        }
    }
   
}

public struct ModelKey {
    
    var column:String
    var keypath:AnyKeyPath
}







