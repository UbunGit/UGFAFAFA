//
//  Page.swift
//  apple (iOS)
//
//  Created by admin on 2021/4/6.
//

import Foundation

struct  UGPage<T:Codable>: Codable{
    

    var page:Int=0 //页码
    var content:Int=10 // 每页个数
    var all:Int = 0 //总个数
    var pages:Int{ // 总页数
        get{
            guard self.content != 0 else {
                return 0
            }
            return all/content
        }
    }
    var datas:T?
    


  
}
