//
//  S_Share.swift
//  apple
//
//  Created by admin on 2021/3/30.
//


import Foundation
import PerfectSQLite
import PerfectHTTP

extension Share{
    /**
     每页个数 content
     页码 page
     */
    static func list(page:Int ,content:Int, callback:@escaping  (Result<[Share], Error>) ->  Void) {
        guard let dbPath = UserDefaults.standard.string(forKey: "dbfile") else {
            print("dbPath is nil")
            return
        }
        let dbfile = "\(dbPath)share.db"
        var contentDict = [Share]()
        do {
            let sqlite = try SQLite(dbfile)
            defer {
                sqlite.close() // This makes sure we close our connection.
            }
            
            let demoStatement = "SELECT id, name, code, ratioIn, ratioOut FROM Share ORDER BY id DESC LIMIT :1 OFFSET :2"
            
            try sqlite.forEachRow(statement: demoStatement, doBindings: {
                
                (statement: SQLiteStmt) -> () in
                
                let page = content*(page-1)
                try statement.bind(position: 1, content)
                try statement.bind(position: 2, page)
                
            }) {(statement: SQLiteStmt, i:Int) -> () in
                
                contentDict.append(
                    Share.init(
                        id: statement.columnInt(position: 0),
                        name: statement.columnText(position: 1),
                        code: statement.columnText(position: 2),
                        ratioIn: statement.columnText(position: 3),
                        ratioOut: statement.columnText(position: 4))
                )
            }
            
            callback(.success(contentDict))
            print(contentDict)
        } catch {
            callback(.failure(error))
        }
        
    }
    
    
    
}


extension HttpServer{
    
    func share_list(request: HTTPRequest, response: HTTPResponse)  {
        defer {
            response.setHeader(.contentType, value: "application/json")
            response.completed()
        }
        
        Share.list(page: 1, content: 10) { (result) in
            switch result {
            case .success(let value):
                let jsonEncoder = JSONEncoder()
                let jsonData = try? jsonEncoder.encode(value)
                let jsonstr = String(data: jsonData!, encoding: .utf8)
                response.appendBody(string: jsonstr!)
            case .failure(let error):
                let errjson = ["code":-1,"msg":error.localizedDescription] as [String : Any]
                let jsonstr =  try! errjson.jsonEncodedString()
                response.appendBody(string: jsonstr)
            }
        }
    }
    
    
}
