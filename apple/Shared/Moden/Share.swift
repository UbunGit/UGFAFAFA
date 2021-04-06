//
//  Share.swift
//  Share
//
//  Created by MBA on 2020/10/4.
//  Copyright © 2020 MBA. All rights reserved.
//

import Foundation
import SQLite

import Combine



struct  Share: Codable , Identifiable {
    
    var id:Int
    var name:String=""
    var code:String=""
    var price:Float?
    var yestodayprice:Float?
    var ratioIn:String="0.95"
    var ratioOut:String="1.00"
    
    var stores: [Store]?
    var storeCount:Int?
  
}


extension Share{
    /**
     获取委买
     */
//    func fitteInstores() ->[PreTransactionModen]{
//        var instores: [PreTransactionModen] = []
//
//        let store =  getminPriceStore()
//        if store != nil {
//
//            let inprice = store!.price * (Float(ratioIn) ?? 0.95)
//            let minprice = ((Float(yestodayprice) ?? 0.00)*0.90)
//            let maxprice = ((Float(yestodayprice) ?? 0.00)*1.10)
//            if (inprice >= minprice &&  inprice <= maxprice)  {
//                instores.append(PreTransactionModen.init(share: self, store: store!))
//            }
//        }
//        return instores
//    }
//
//    /**
//     获取委卖
//     */
//    func fitteOutstores() ->[PreTransactionModen] {
//        var outstores: [PreTransactionModen] = []
//
//        let store =  getminPriceStore()
//        if store != nil {
//            let outprice = store!.price * (Float(ratioOut) ?? 1.10)
//            let minprice = ((Float(yestodayprice) ?? 0.00)*0.90)
//            let maxprice = ((Float(yestodayprice) ?? 0.00)*1.10)
//            if (outprice >= minprice && outprice <= maxprice)  {
//                outstores.append(PreTransactionModen.init(share: self, store: store!))
//            }
//        }
//
//        return outstores
//    }
//
    func getAllNum() -> Int {
        guard let store = self.stores else {
            return 0
        }
        var num = 0
        for item in store {
            if item.num>0 {
                num = num+item.num
            }
        }
        return num
    }
    
    func getAllPrice() -> Float {
        
        guard let store = self.stores else {
            return 0
        }
        var inprice:Float = 0
        for item in store {
            inprice = inprice+(item.price*Float(item.num))
        }
        return inprice
    }
    
    func getInPrice()  -> Float{
        guard let store = self.stores else {
            return 0
        }
        var inprice:Float = store[0].price
        for item in store {
            if item.num>0 {
                inprice = min(item.price, inprice)
            }
        }
        return inprice*(Float(ratioIn) ?? 0.95)
    }
    
    func getOutPrice() -> Float {
        guard let stores = self.stores else {
            return 0
        }
        var inprice:Float = stores[0].price
        for item in stores {
            if item.num>0 {
                inprice = min(item.price, inprice)
            }
        }
        return inprice*(Float(ratioOut) ?? 1.05)
    }
    
    func getminPriceStore()  -> Store?{
        guard let stores = self.stores else {
            return nil
        }
        var store = stores[0]
        var inprice:Float = stores[0].price
        for item in stores {
            if item.num>0 {
                if item.price < inprice {
                    inprice = item.price
                    store = item;
                }
            }
        }
        return store
    }
    
    /**
     获取收益
     */
    func getIncome() -> Float {
        return 0
//        guard let stores = self.outstores else {
//            return 0
//        }
//        var income:Float = 0
//        for store in stores {
//            if store.state == 1 {
//                let outprice:Float = store.outprice ?? 0.00
//                let price:Float = store.price
//                let fee:Float = store.fee ?? 0.00
//                income = income + ((outprice - price) * Float(store.num))-fee
//            }
//        }
//        return income
    }
    
    
}


// MARK: DB
extension Share{
    
//    static func row_to(row:SQLite.Row)->Share{
//        var share = Share()
//        share.id = UUID(number: Int((row[Expression<Int64>("id")])))
//        share.name = "\(row[Expression<String?>("name")] ?? "")"
//        share.code = "\(row[Expression<String?>("code")] ?? "")"
//        share.price = "\(row[Expression<String?>("price")] ?? "")"
//        share.yestodayprice = "\(row[Expression<String?>("yestodayprice")] ?? "")"
//        share.ratioIn = "\(row[Expression<String?>("ratioIn")] ?? "")"
//        share.ratioOut = "\(row[Expression<String?>("ratioOut")] ?? "")"
//        share.stores = Store.db_stores(shareid: Int64(share.id)).filter({ (store) -> Bool in
//            Int(store.state ?? 0) == 0
//        })
//        share.outstores = Store.db_stores(shareid: Int64(share.id)).filter({ (store) -> Bool in
//            store.state == 1
//        })
//        return share
//    }
    
    static func db_shares(finesh:@escaping  (NSError?, [Share]?) ->  ()) {
        
//        let share = Table("Share")
//        do {
//            let query = try db?.prepare(share)
//            let list:[Share] =  query?.map({ row -> Share in
//                return Share.row_to(row: row)
//            }) ?? [Share]()
//            finesh(nil,list)
//        } catch {
//            debugPrint("\(self) \(#function) error db_shares: \(error)")
//            finesh(error as NSError,nil)
//        }
    }
    
    static func db_share(id:Int, finesh:@escaping  (NSError?, Share?) ->  ()) {
        
//        let share = Table("Share")
//        do {
//            let query = try db?.prepare(share.filter(Expression<Int64>("id") == Int64(id)))
//            let list:[Share] =  query?.map({ row -> Share in
//                return Share.row_to(row: row)
//            }) ?? [Share]()
//            if list.count>0 {
//                finesh(nil,list[0])
//            }else{
//                finesh(NSError.init(domain: "share not found" , code: -1, userInfo: nil),nil)
//            }
//
//        } catch {
//            debugPrint("\(self) \(#function) error db_shares_id: \(error)")
//            finesh(error as NSError,nil)
//        }
    }
    
    func db_share(id:Int?,finesh:@escaping  (Error?, Share?) ->  ()) {
//        let share = Table("Share")
//        do {
//            if nil != id {
//                let alice = share.filter(Expression<Int64>("id") == Int64(id!))
//                var setters = [SQLite.Setter]()
//                if name.count>0 {
//                    setters.append(Expression<String?>("name") <- name)
//                }
//                if code.count>0 {
//                    setters.append(Expression<String?>("code") <- code)
//                }
//                if price?.count ?? 0>0 {
//                    setters.append(Expression<String?>("price") <- price)
//                }
//                if yestodayprice?.count ?? 0>0 {
//                    setters.append(Expression<String?>("yestodayprice") <- yestodayprice)
//                }
//                if ratioIn.count>0 {
//                    setters.append(Expression<String?>("ratioIn") <- ratioIn)
//                }
//
//                if ratioOut.count>0 {
//                    setters.append(Expression<String?>("ratioOut") <- ratioOut)
//                }
//
//                let rowid =  try db?.run(alice.update(setters))
//                if rowid ?? 0>0{
//                    finesh(nil,self)
//                }else{
//                    finesh(NSError.init(domain: "share not found" , code: -1, userInfo: nil),nil)
//                }
//
//            }else{
//                let rowid = try db?.run(share.insert(
//                    Expression<String?>("name") <- name,
//                    Expression<String?>("code") <- code,
//                    Expression<String?>("price") <- price,
//                    Expression<String?>("yestodayprice") <- yestodayprice,
//                    Expression<String?>("ratioIn") <- ratioIn,
//                    Expression<String?>("ratioOut") <- ratioOut
//                ))
//                if rowid ?? 0>0{
//                    var temshare = self
//                    temshare.id = Int(rowid!)
//                    finesh(nil,temshare)
//                }else{
//                    finesh(NSError.init(domain: "share not found" , code: -1, userInfo: nil),nil)
//                }
//
//            }
//        } catch {
//            debugPrint("\(self) \(#function) error: \(error)")
//            finesh(error as NSError,nil)
//        }
        
    }
    
 
    
    func db_delete(finesh:@escaping  (NSError?) ->  ())  {
//        let share = Table("Share")
//        do {
//            let alice = share.filter(Expression<Int64>("id") == Int64(id))
//            let rowid = try db?.run(alice.delete())
//            if rowid ?? 0>0{
//                var temshare = self
//                temshare.id = Int(rowid!)
//                finesh(nil)
//            }else{
//                finesh(NSError.init(domain: "share not found" , code: -1, userInfo: nil))
//            }
//            
//        } catch {
//            debugPrint("\(self) \(#function) error: \(error)")
//            finesh(error as NSError)
//        }
    }
    
    
}


// MARK: TESTDATA
extension Share{
    
    static let _shares:[Share] = [
        Share.init(id:0, name: "积分科技", code: "300022",price: 12.00, stores:Store._stores),
        Share.init(id:1, name: "科技ETF", code: "300022",price: 12.00, stores:Store._stores)
    ]
}

