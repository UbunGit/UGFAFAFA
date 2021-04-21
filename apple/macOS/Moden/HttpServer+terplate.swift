//
//  Moden.swift
//  apple
//
//  Created by admin on 2021/4/21.
//

import Foundation
import PerfectSQLite
import PerfectCRUD

public protocol CRUDSqliteProtocol:Identifiable{
    /**
     数据库地址
     */
    static var dbfile:String{get}
    
    /**
     删除
     */
    static func delete(id:Int, callback:@escaping  (Result<Int, Error>) ->  Void)
    
    
}

//extension CRUDSqliteProtocol{
//    
//    static func delete(id:Int, callback:@escaping  (Result<Int, Error>) ->  Void){
//   
//        do {
//            let db = Database(configuration: try SQLiteDatabaseConfiguration(dbfile))
//            try db.table(Self.self)
//                .where(\Self.id == id)
//                .delete()
//            callback(.success(1))
//        } catch {
//            callback(.failure(error))
//        }
//    }
//}
