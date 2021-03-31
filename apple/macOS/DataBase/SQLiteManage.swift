//
//  dbManage.swift
//  apple (iOS)
//
//  Created by admin on 2021/3/26.
//

import Foundation
import SQLite

var dbfile = UserDefaults.standard.string(forKey: "dbfile")
var db = try? Connection(dbfile!)

class SQLiteManage: NSObject {
    static func updatefile()  {
        dbfile = UserDefaults.standard.string(forKey: "dbfile")
        db = try? Connection(dbfile!)
    }
}
extension Connection {
    
    public var userVersion: Int32 {
        get { return Int32(try! scalar("PRAGMA user_version") as! Int64)}
        set { try! run("PRAGMA user_version = \(newValue)") }
    }
}
