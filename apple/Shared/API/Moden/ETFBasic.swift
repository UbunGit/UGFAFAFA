//
//  EFTBase.swift
//  apple
//
//  Created by admin on 2021/7/15.
//

import Foundation

public struct ETFBasic:Codable {
    
    var name:String = ""
    var code:String = ""
    var changeTime:String = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case code
        case changeTime
    }
}
