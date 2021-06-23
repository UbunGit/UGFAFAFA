//
//  AnalyseCache.swift
//  apple
//
//  Created by admin on 2021/6/23.
//

import Foundation

struct AnalyseCache: Analyse {
    var id:String = ""
    var name:String = ""
    var parmas:String = ""
    var begin:String = ""
    var end:String = ""
    var codes:String = ""
    var result:String = ""
    var create_time:String = ""
    var change_time:String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case parmas
        case begin
        case end
        case codes
        case result
        case create_time
        case change_time
 
    }
}

extension AnalyseCache{
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        parmas = try container.decode(String.self, forKey: .parmas)
        begin = try container.decode(String.self, forKey: .begin)
        end = try container.decode(String.self, forKey: .end)
        begin = try container.decode(String.self, forKey: .begin)
        codes = try container.decode(String.self, forKey: .codes)
        let tresult = try container.decodeIfPresent(String.self, forKey: .result)
        result = tresult ?? ""
        create_time = try container.decode(String.self, forKey: .create_time)
        let tchange_time = try container.decodeIfPresent(String.self, forKey: .change_time)
        change_time = tchange_time ?? ""
        
    }
}
