//
//  S_Share.swift
//  apple
//
//  Created by admin on 2021/3/30.
//


import Foundation
import PerfectSQLite
import PerfectCRUD
import PerfectHTTP

extension Share{
    /**
     每页个数 content
     页码 page
     */
    static func list(page:Int ,content:Int, callback:@escaping  (Result<[Share], Error>) ->  Void) {
//        guard let dbPath = UserDefaults.standard.string(forKey: "dbfile") else {
//            print("dbPath is nil")
//            return
//        }
//        let dbfile = "\(dbPath)share.db"
//        var contentDict = [Share]()
//        do {
//            let sqlite = try SQLite(dbfile)
//            defer {
//                sqlite.close() // This makes sure we close our connection.
//            }
//
//            let demoStatement = "SELECT id, name, code, ratioIn, ratioOut FROM Share ORDER BY id DESC LIMIT :1 OFFSET :2"
//
//            try sqlite.forEachRow(statement: demoStatement, doBindings: {
//
//                (statement: SQLiteStmt) -> () in
//
//                let page = content*(page-1)
//                try statement.bind(position: 1, content)
//                try statement.bind(position: 2, page)
//
//            }) {(statement: SQLiteStmt, i:Int) -> () in
//
//                contentDict.append(
//                    Share.init(
//                        id:statement.columnInt(position: 0),
//                        name: statement.columnText(position: 1),
//                        code: statement.columnText(position: 2),
//                        ratioIn: statement.columnText(position: 3),
//                        ratioOut: statement.columnText(position: 4))
//                )
//            }
//
//            callback(.success(contentDict))
//            print(contentDict)
//        } catch {
//            callback(.failure(error))
//        }
        
        guard let dbPath = UserDefaults.standard.string(forKey: "dbfile") else {
            print("dbPath is nil")
            return
        }
        let page = content*(page-1)
        let dbfile = "\(dbPath)share.db"
        do {
            let db = Database(configuration: try SQLiteDatabaseConfiguration(dbfile))
            let shareTable = db.table(Share.self)
            
            let values = try shareTable
                
                .join(\.stores, on: \.id, equals: \.share_id)
                .limit(content,skip: page)
                .select().map { $0 }
               
             
            callback(.success(values))
        } catch {
            callback(.failure(error))
        }
        
    }
    
    static func detail(id:Int, callback:@escaping  (Result<Share?, Error>) ->  Void) {
        guard let dbPath = UserDefaults.standard.string(forKey: "dbfile") else {
            print("dbPath is nil")
            return
        }
        let dbfile = "\(dbPath)share.db"
        do {
            let db = Database(configuration: try SQLiteDatabaseConfiguration(dbfile))
            let shareTable = db.table(Share.self)
            
            let query = try shareTable
                .join(\.stores, on: \.id, equals: \.share_id)
                .where(\Share.id == id)
                .first()
            callback(.success(query))
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
        
        guard let page = request.param(name: "page") else {
            response.appendBody(string: "page 不能为空")
            return
        }
        guard let content = request.param(name: "content") else {
            response.appendBody(string: "content 不能为空")
            return
        }
        
        Share.list(page: Int(page)!, content: Int(content)!) { (result) in
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
    
    func share_detail(request: HTTPRequest, response: HTTPResponse)  {
        defer {
            response.setHeader(.contentType, value: "application/json")
            response.completed()
        }
        
        guard let id = request.param(name: "id") else {
            response.appendBody(string: "id 不能为空")
            return
        }
        
        
        Share.detail(id: Int(id)!) { (result) in
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
