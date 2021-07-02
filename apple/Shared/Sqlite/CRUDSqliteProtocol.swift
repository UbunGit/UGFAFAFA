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
    var sqliteFile:String{ get  }
    var sqliteCon:Connection?{ get  }
    var tableName:String{ get  }
}

extension SqliteProtocol{
    
    public var sqliteFile:String{
        return  UserDefaults.standard.string(forKey: "dbfile") ?? "\(KDocumnetPath)/Sqlite/sqlite.db"
    }
    public var sqliteCon:Connection?{
        return try? Connection(sqliteFile)
    }
    public var tableName:String{
        let tname = "\(type(of: self))".lowercased()
        return tname
    }
   
}







