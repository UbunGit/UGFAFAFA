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


extension Share: CRUDSqliteProtocol{
    
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
        try table.where(\Share.id == self.id)
            .update(self)
        
    }
    
    /**
     每页个数 content
     页码 page
     */
    static func list(page:Int ,content:Int) throws ->UGPage<[Share]>{
        
        
        guard let dbPath = UserDefaults.standard.string(forKey: "dbfile") else {
            throw APIError(code: -1, msg: "查询数据异常")
            
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
            return UGPage<[Share]>(page: page, content: content, all:try values.count(), datas:datas )
            
            //            if let values = try shareTable
            //                .join(\.stores, on: \.id, equals: \.share_id)
            //                .limit(content,skip: page)
            //                .select(){
            //                return UGPage<[Share]?>(page: page, content: content, all:try values.count(), datas:datas )
            //            }else{
            //
            //                throw APIError(code: -1, msg: "查询数据异常")
            //            }
            
        } catch {
            throw APIError(code: -1, msg: "查询数据异常")
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
    
    
    static func handler(request: HTTPRequest, response: HTTPResponse)  {
        
    }
    
    
    static func list(request: HTTPRequest, response: HTTPResponse)  {
        
        guard let page = request.param(name: "page") else {
            response.appendBody(string: "page 不能为空")
            return
        }
        guard let content = request.param(name: "content") else {
            response.appendBody(string: "content 不能为空")
            return
        }
        do{
            let data = try Share.list(page: Int(page)!, content: Int(content)!)
            response.apiCompleted(result:data, error: nil)
        }catch{
            response.apiCompleted( result: "", error: error as? APIError)
        }
       
        //        Share.list(page: Int(page)!, content: Int(content)!) { (result) in
        //            switch result {
        //            case .success(let value):
        //                let jsonEncoder = JSONEncoder()
        //                let jsonData = try? jsonEncoder.encode(value)
        //                let jsonstr = String(data: jsonData!, encoding: .utf8)
        //                response.appendBody(string: jsonstr!)
        //            case .failure(let error):
        //                let errjson = ["code":-1,"msg":error.localizedDescription] as [String : Any]
        //                let jsonstr =  try! errjson.jsonEncodedString()
        //                response.appendBody(string: jsonstr)
        //                NSLog(jsonstr)
        //            }
        //        }
    }
    
    
    
}


extension HttpServer {
    
    func share_update(request: HTTPRequest, response: HTTPResponse)  {
        
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
            var share = Share(id: id, name: name, code: code)
            if id == 0 {
                share.id = try share.insert(ignoreKeys: \Share.id)
            }else{
                try share.update()
            }
            response.apiCompleted( result:share, error: nil)
        }
        catch{
            response.apiCompleted( result: "", error: error as? APIError)
        }
    }
    
    //    func share_list(request: HTTPRequest, response: HTTPResponse)  {
    //
    //        guard let page = request.param(name: "page") else {
    //            response.appendBody(string: "page 不能为空")
    //            return
    //        }
    //        guard let content = request.param(name: "content") else {
    //            response.appendBody(string: "content 不能为空")
    //            return
    //        }
    //
    //        Share.list(page: Int(page)!, content: Int(content)!) { (result) in
    //            switch result {
    //            case .success(let value):
    //                let jsonEncoder = JSONEncoder()
    //                let jsonData = try? jsonEncoder.encode(value)
    //                let jsonstr = String(data: jsonData!, encoding: .utf8)
    //                response.appendBody(string: jsonstr!)
    //            case .failure(let error):
    //                let errjson = ["code":-1,"msg":error.localizedDescription] as [String : Any]
    //                let jsonstr =  try! errjson.jsonEncodedString()
    //                response.appendBody(string: jsonstr)
    //                NSLog(jsonstr)
    //            }
    //        }
    //    }
    
    func share_detail(request: HTTPRequest, response: HTTPResponse)  {
        
        guard let id = request.param(name: "id") else {
            response.appendBody(string: "id 不能为空")
            return
        }
        do {
            
            let share = try Share.detail(id: Int(id)!)
            response.apiCompleted( result:share, error: nil)
        } catch {
            response.apiCompleted( result: nil, error: error as? APIError)
        }
        
    }
    
    func share_delete(request: HTTPRequest, response: HTTPResponse)  {
        
        guard let id = Int(request.param(name: "id") ?? "0")  else {
            response.appendBody(string: "id 错误")
            return
        }
        do {
            try Share.delete((\Share.id == id))
            response.apiCompleted( result:nil, error: nil)
        }catch{
            response.apiCompleted(result: nil, error: error as? APIError)
        }
    }
}
