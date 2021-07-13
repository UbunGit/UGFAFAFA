//
//  GroupShare.swift
//  apple
//
//  Created by admin on 2021/5/29.
//

import Foundation

public struct StockBasic:Codable {
    
    var name:String = ""
    var code:String = ""
    var area:String = ""
    var industry:String = ""
    var market:String = ""
    var changeTime:String = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case code
        case area
        case industry
        case market
        case changeTime
    }
}
