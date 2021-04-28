//
//  File.swift
//  
//
//  Created by admin on 2021/4/27.
//

import Foundation
import PerfectSQLite
import PerfectCRUD
/*:
 数据更新时间记录
 */



public struct DataCache:CodableIdentifiable{
    
    public var id: UUID
    public var key:String // 关键字
    public var value:String // 修改时间
    
    init(key:String,value:String) {
        self.key = key
        self.value = value
        self.id = UUID()
    }
}
public typealias CodableIdentifiable = Codable&Identifiable

// CRUD
extension DataCache:CRUDable{
    
    public typealias T = DataCache
    
    public static var dbfile:String{
        get{
            return analyse_db
        }
    }
    
    public func instet() throws -> DataCache {
        
        try Self.table().insert(self)
        return self
    }
    
    public func update() throws  -> DataCache{
        try Self.table().where(\Self.id == id).update(self)
        return self
    }
    
    public static func delete(id:UUID) throws{
        
        try DataCache.table().where(\DataCache.id == id).delete()
    }
    
    public static func select(id:UUID) throws -> T{
        guard let data = try DataCache.table().where(\Self.id == id).first() else {
            throw BaseError(code: -1, msg: "empyt data")
        }
        return data
    }
    
    public static func search(_ exp: CRUDBooleanExpression, page: Int, pageSize: Int) throws -> UGPage<DataCache> {
        let offset = pageSize*(page-1)
        let alldata = try DataCache.table().where(exp)
        let all = try alldata.count()
        
        let selectdata = try DataCache.table()
            .order(by: \Self.id)
            .limit(pageSize,skip: offset)
            .where(exp)
        
        let rdata = try selectdata.select().map{ return $0 }
        
        return UGPage(page: page, pageSize: pageSize, all: all, datas: rdata)
    }
    
    public static func value(of key:String) throws -> String?{
        try Self.table().where(\DataCache.key == key).first()?.value
    }
    
    public static func setvalue(_ value:String, for key:String) throws{
        var data = try Self.table().where(\DataCache.key == key).first()
        if data == nil {
            let _ = try DataCache(key: key, value: value).instet()
        }else{
            data?.value = value
            let _ = try data?.update()
        }
    }
    public static func remove(_ key:String)  throws{
       try Self.table().where(\DataCache.key == key).delete()
    }
}




