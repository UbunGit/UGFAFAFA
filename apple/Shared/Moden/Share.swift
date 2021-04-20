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
    
    var id:Int = 0
    var name:String=""
    var code:String=""
    var price:Float?
    var yestodayprice:Float?
    var ratioIn:String="0.95"
    var ratioOut:String="1.00"
    
    var stores: [Store]?
//    var storeCount:Int = 0
  
}



// MARK: TESTDATA
extension Share{
    
    static let _shares:[Share] = [
        Share.init(id:0, name: "积分科技", code: "300022",price: 12.00, stores:Store._stores),
        Share.init(id:1, name: "科技ETF", code: "300022",price: 12.00, stores:Store._stores)
    ]
}

