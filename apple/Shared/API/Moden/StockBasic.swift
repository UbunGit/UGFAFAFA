//
//  GroupShare.swift
//  apple
//
//  Created by admin on 2021/5/29.
//

import Foundation
import HandyJSON

public struct StockBasic:Codable  {
    
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
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let tname = try container.decodeIfPresent(String.self, forKey: .name)
        let tcode = try container.decodeIfPresent(String.self, forKey: .code)
        let tarea = try container.decodeIfPresent(String.self, forKey: .area)
        let tindustry = try container.decodeIfPresent(String.self, forKey: .industry)
        let tmarket = try container.decodeIfPresent(String.self, forKey: .market)
        let tchangeTime = try container.decodeIfPresent(String.self, forKey: .changeTime)
        name = tname ?? ""
        code = tcode ?? ""
        area = tarea ?? ""
        industry = tindustry ?? ""
        market = tmarket ?? ""
        changeTime = tchangeTime ?? ""
        
    }
    
}
