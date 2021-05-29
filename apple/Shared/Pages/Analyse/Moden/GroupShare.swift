//
//  GroupShare.swift
//  apple
//
//  Created by admin on 2021/5/29.
//

import Foundation

struct GroupShare:Codable {
    
    var name:String = ""
    var code:String = ""
    var area:String = ""
    var industry:String = ""
    var market:String = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case code
        case area
        case industry
        case market
    }
  
}
