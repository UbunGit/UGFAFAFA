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
    
    /*
     修改股票
     */
    func update() throws ->Void{
        
        guard let dbPath = UserDefaults.standard.string(forKey: "dbfile") else {
            print("dbPath is nil")
            return
        }
        let dbfile = "\(dbPath)share.db"
        
        let db = Database(configuration: try SQLiteDatabaseConfiguration(dbfile))
        let table = db.table(Share.self)
        if id != 0 {
            try table
                .where(\Share.id == self.id)
                .update(self)
            
        }else{
            
            try table.insert(self, ignoreKeys: \.id)
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
            
            let datas = try values.select().map { return $0 }
            
            let page = UGPage<[Share]?>(page: page, content: content, all:try values.count(), datas:datas )
            callback(.success(page))
        } catch {
            callback(.failure(error))
        }
        
    }
    
    /*
     获取股票详情
     */
    static func detail(id:Int) throws ->Share {
        guard let dbPath = UserDefaults.standard.string(forKey: "dbfile") else {
            
            throw APIError(code:-1,msg:"dbPath is nil")
        }
        let dbfile = "\(dbPath)share.db"
        
        let db = Database(configuration: try SQLiteDatabaseConfiguration(dbfile))
        let shareTable = db.table(Share.self)
        
        if let share = try shareTable
            .join(\.stores, on: \.id, equals: \.share_id)
            .where(\Share.id == id)
            .first(){
            return share
        }else{
            throw APIError(code: -1, msg: "查询数据为空")
        }
        
        
    }
    
    static func delete(id:Int, callback:@escaping  (Result<Int, Error>) ->  Void) {
        
        guard let dbPath = UserDefaults.standard.string(forKey: "dbfile") else {
            print("dbPath is nil")
            return
        }
        let dbfile = "\(dbPath)share.db"
        do {
            let db = Database(configuration: try SQLiteDatabaseConfiguration(dbfile))
            try db.table(Self.self)
                .where(\Share.id == id)
                .delete()
            callback(.success(1))
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
        guard let id = Int(request.param(name: "id") ?? "0")  else {
            response.appendBody(string: "id 错误")
            return
        }
        guard let code = request.param(name: "code")  else {
            response.appendBody(string: "page 不能为空")
            return
        }
        guard let name = request.param(name: "name")  else {
            response.appendBody(string: "name 不能为空")
            return
        }
        
        do{
            let share = Share(id: id, name: name, code: code)
            try share.update()
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(share)
            let jsonstr = String(data: jsonData!, encoding: .utf8)
            response.appendBody(string: jsonstr!)
        }
        catch{
            let errjson = ["🐬 code":-1,"msg":error.localizedDescription] as [String : Any]
            let jsonstr =  try! errjson.jsonEncodedString()
            response.appendBody(string: jsonstr)
            NSLog(jsonstr)
        }
        
        
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
                NSLog(jsonstr)
            }
        }
    }
    
    func share_detail(request: HTTPRequest, response: HTTPResponse)  {
    
    
        
        guard let id = request.param(name: "id") else {
            response.appendBody(string: "id 不能为空")
            return
        }
        do {
            
            let share = try Share.detail(id: Int(id)!)
            apiCompleted(response:response, result:share, error: nil)
        } catch {

            apiCompleted(response:response, result: nil, error: error as! APIError)
           
        }
        
        
    }
    
    func share_delete(request: HTTPRequest, response: HTTPResponse)  {
        defer {
            response.setHeader(.contentType, value: "application/json")
            response.completed()
        }
        guard let id = Int(request.param(name: "id") ?? "0")  else {
            response.appendBody(string: "id 错误")
            return
        }
        
        Share.delete(id: id) { (result) in
            switch result {
            case .success( _):
                let errjson = ["data": "删除成功"] as [String : Any]
                let jsonstr =  try! errjson.jsonEncodedString()
                response.appendBody(string: jsonstr)
            case .failure(let error):
                let errjson = ["🐬 code":-1,"msg":error.localizedDescription] as [String : Any]
                let jsonstr =  try! errjson.jsonEncodedString()
                response.appendBody(string: jsonstr)
                NSLog(jsonstr)
                
            }
        }
        
    }
    
    
}
