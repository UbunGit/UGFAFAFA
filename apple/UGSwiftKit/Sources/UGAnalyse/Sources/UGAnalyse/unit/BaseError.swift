//
//  File.swift
//  
//
//  Created by admin on 2021/4/27.
//

import Foundation

public struct BaseError:Error {
    var code:Int
    var msg:String
}

public struct UGPage<T:Codable>: Codable{

    var page:Int=0 //页码
    var pageSize:Int=10 // 每页个数
    var all:Int = 0 //总个数
    var allPages:Int{ // 总页数
        get{
            guard self.pageSize != 0 else {
                return 0
            }
            return all/pageSize
        }
    }
    var datas:[T]?
}
