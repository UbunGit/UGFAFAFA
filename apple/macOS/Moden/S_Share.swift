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
    
    func update(callback:@escaping  (Result<Share, Error>) ->  Void){
        
        guard let dbPath = UserDefaults.standard.string(forKey: "dbfile") else {
            print("dbPath is nil")
            return
        }
        let dbfile = "\(dbPath)share.db"
        
        do{
           
            let db = Database(configuration: try SQLiteDatabaseConfiguration(dbfile))
            let table = db.table(Share.self)
            if id != 0 {
                try table.update(self)
            }else{
                try table.insert(self)
            }
        }catch {
            callback(.failure(error))
        }
        
    }
    /**
     每页个数 content
     页码 page
     */
    static func list(page:Int ,content:Int, callback:@escaping  (Result<UGPage<[Share]?>, Error>) ->  Void) {

        
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
//                .where(\Share.name %=% "ETF")
      
            
            let datas = try values.select().map { return $0 }
       
            let page = UGPage<[Share]?>(page: page, content: content, all:try values.count(), datas:datas )
            callback(.success(page))
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
    
    func share_update(request: HTTPRequest, response: HTTPResponse)  {
        defer {
            response.setHeader(.contentType, value: "application/json")
            response.completed()
        }
        do{
            let params = request.params()
            var par = [String:Any]()
            for p in params {
                par[p.0] = p.1
            }
          
            let jsonData = try JSONSerialization.data(withJSONObject: par as Any, options: [])
            let data = try JSONDecoder().decode(Share.self, from: jsonData)
        }
        catch {
            response.appendBody(string: "\(error)")
          
       }
      
        
//        guard let page = request.param(name: "name") else {
//            response.appendBody(string: "page 不能为空")
//            return
//        }
//        guard let content = request.param(name: "content") else {
//            response.appendBody(string: "content 不能为空")
//            return
//        }
        
        
       
    }
    
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
