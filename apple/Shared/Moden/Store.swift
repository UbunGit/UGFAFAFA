//
//  Store.swift
//  Share
//
//  Created by admin on 2020/10/14.
//  Copyright © 2020 MBA. All rights reserved.
//

import Foundation
import SQLite


struct Store: Codable, Identifiable,Equatable {
    
    var id = 0
    var share_id:Int?
    var price:Float = 0.00
    var num:Int = 0
    var day:String? = Date().toString(dateFormat: "yyyy-MM-dd")
    var state:Int? = 0 //0 ->买入 1->卖出
    var outprice:Float? = 0.00
    var outday:String? = Date().toString(dateFormat: "yyyy-MM-dd")
    var fee:Float? = 0.00
    
}
extension Store{
    /**
     获取成本金额
     */
    func getAllprice() -> Float {
        
        return price * Float(num)
    }
}


/**
 db
 */
extension Store{
    /**
     获取 Store列表
     */
    static func db_stores(finesh:@escaping  (NSError?, [Store]?) ->  ()){
        let store = Table("Store")
        do {
            let list:[Store] = try db?.prepare(store.order(Expression<String?>("day"))).map({ (row) -> Store in
                return try row.decode()
            })  ?? [Store]()
            finesh(nil,list)
        } catch {
            debugPrint("\(self) \(#function) error: \(error)")
            finesh(NSError.init(domain: "share not found" , code: -1, userInfo: nil),nil)
        }
    }
    
    /**
     根据share_id获取下面的stores
     */
    static func db_stores(shareid:Int64) -> [Store] {
        
        let store = Table("Store")
        do {
            let list:[Store]? = try db?.prepare(store.filter(Expression<Int64>("share_id") == shareid).order(Expression<String?>("day").desc)).map({ (row) -> Store in
                return try row.decode()
            })

            return list ?? [Store]()
        } catch {
            debugPrint("\(self) \(#function) error: \(error)")
            return [Store]()
        }
    }
    
    /**
     根据id获取下面的store
     */
    static func db_store(storeId:Int,finesh:@escaping  (Error?, Store?) ->  ()){
        
        let store = Table("Store")
        do {
            let list:[Store]? = try db?.prepare(store.filter(Expression<Int64>("id") == Int64(storeId)))
                .map({ (row) -> Store in
                return try row.decode()
            })
            finesh(nil,list?.first)
        } catch {
            finesh(error,nil)
        }
    }
    
    /**
     新增/修改
     var id = 0
     var share_id:Int?
     var price:Float = 0.00
     var num:Int = 0
     var day:String = Date().toString(dateFormat: "yyyy-MM-dd")
     */
    func db_store(id:Int?,finesh:@escaping  (NSError?, Store?) ->  ()) {
        let store = Table("Store")
        do {
            if id ?? 0>0 {
                let alice = store.filter(Expression<Int64>("id") == Int64(id!))
                let setarr = self.db_decode()
                let rowid = try db?.run(alice.update(setarr))
                if rowid ?? 0>0{
                    finesh(nil,self)
                }else{
                    finesh(NSError.init(domain: "share not found" , code: -1, userInfo: nil),nil)
                }
                
            }else{
                let setarr = self.db_decode()
                let rowid = try db?.run(store.insert(setarr))
                if rowid ?? 0>0{
                    var temshare = self
                    temshare.id = Int(rowid!)
                    finesh(nil,temshare)
                }else{
                    finesh(NSError.init(domain: "share not found" , code: -1, userInfo: nil),nil)
                }
                
            }
        } catch {
            debugPrint("\(self) \(#function) error: \(error)")
            finesh(error as NSError,nil)
        }
    }
    
    
    func db_delete(id:Int?,finesh:@escaping  (NSError?) ->  ()){
        let store = Table("Store")
        
   
        do {
            let alice = store.filter(Expression<Int64>("id") == Int64(self.id))
            let rowid = try db?.run(alice.delete())
            if rowid ?? 0>0{
                var temshare = self
                temshare.id = Int(rowid!)
                finesh(nil)
            }else{
                finesh(NSError.init(domain: "share not found" , code: -1, userInfo: nil))
            }
            
        } catch {
            debugPrint("\(self) \(#function) error: \(error)")
            finesh(error as NSError)
        }
    }
    
    func db_decode() -> [SQLite.Setter] {
        var setarr = [SQLite.Setter]()
        if Int64(share_id ?? 0)>0 {
            setarr.append(Expression<Int64>("share_id") <- Int64(share_id!))
        }
        if Float64(price)>0 {
            setarr.append(Expression<Float64>("price") <- Float64(price))
        }
        
        if Int64(num)>=0 {
            setarr.append(Expression<Int64>("num") <- Int64(num))
        }
        
        if day?.count ?? 0>0 {
            setarr.append(Expression<String?>("day") <- day)
        }
        
        if Int64(state ?? 0)>0 {
            setarr.append(Expression<Int64>("state") <- Int64(state ?? 0))
        }
        
        if Float64(outprice ?? 0.00)>0 {
            setarr.append(Expression<Float64>("outprice") <- Float64(outprice ?? 0.00))
        }
        
        if outday?.count ?? 0>0 {
            setarr.append(Expression<String?>("outday") <- outday)
        }
        
        if Float64(fee ?? 0.00)>0 {
            setarr.append(Expression<Float64>("fee") <- Float64(fee ?? 0.00))
        }
  
        return setarr
    }
    

}


extension Store{
    static let _stores = [
        Store.init(id: 0, price: 4.00, num: 12300, day: "2020.10.12",state: 0, outprice: 5.00,outday: "2020.10.13"),
        Store.init(id: 1, price: 5.00, num: 11300, day: "2020.10.12",state: 1, outprice: 5.00,outday: "2020.10.13"),
        
    ]
}

