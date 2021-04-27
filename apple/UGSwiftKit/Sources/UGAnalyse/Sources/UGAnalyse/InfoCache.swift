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
public struct InfoCache: Codable{
    

    var key:String // 文件名或表名
    var value:String // 修改时间
    init(key:String,value:String) {
        self.key = key
        self.value = value
    }
}

extension InfoCache{
    
    public static func save(key:String, value:String) throws {
        let data = InfoCache(key: key, value: value)
        let db = Database(configuration: try SQLiteDatabaseConfiguration(analyse_db))
        let table = db.table(InfoCache.self)
        try table.insert(data)
    }
}
