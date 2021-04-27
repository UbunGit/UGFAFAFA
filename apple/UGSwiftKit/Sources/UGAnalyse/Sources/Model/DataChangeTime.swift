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
public struct DataChangeTime,Codable , Identifiable{
    
    var key:String? // 文件名或表名
    var date:String? // 修改时间
    
}

extension DataChangeTime{
    
   static func save(data:DataChangeTime) throws {
        
        let db = Database(configuration: try SQLiteDatabaseConfiguration(analyse_db))
        let table = db.table(DataChangeTime.self)
        try table.inster(data)
    }
}
