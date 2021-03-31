//
//  Tractic.swift
//  apple (macOS)
//
//  Created by admin on 2021/3/29.
//

import Foundation
import PerfectSQLite
import PerfectHTTP

extension HttpServer{
    
    func tactics(request: HTTPRequest, response: HTTPResponse) {
        
        guard let dbPath = UserDefaults.standard.string(forKey: "dbfile") else {
            print("dbPath is nil")
            return
        }
        
        var contentDict = [[String: Any]]()
         
        do {
            let sqlite = try SQLite(dbPath)
            defer {
                sqlite.close() // 此处确定关闭数据连接
            }
         
            let demoStatement = "SELECT id, name FROM tactics ORDER BY id DESC LIMIT :1"
         
            try sqlite.forEachRow(statement: demoStatement, doBindings: {
                (statement: SQLiteStmt) -> () in
         
                let bindValue = 5
                try statement.bind(position: 1, bindValue)
         
            }) {(statement: SQLiteStmt, i:Int) -> () in
         
                contentDict.append([
                    "id": statement.columnText(position: 0),
                    "name": statement.columnText(position: 1),
                ])
            }
            
            response.setHeader(.contentType, value: "application/json")
            let jsonstr =  try contentDict.jsonEncodedString()
            response.appendBody(string: jsonstr)
            response.completed()
        } catch {
            response.setHeader(.contentType, value: "application/json")
     
            response.appendBody(string: "\(error)")
            response.completed()
            // 错误处理
        }
        

    }
}
