//
//  Analyse.swift
//  apple
//
//  Created by admin on 2021/5/27.
//


struct Analyse:Codable {
    
    var params:[Param] = []
    var name:String = ""
    var des:String?
    
    var begin:String = ""
    var end:String = ""
    var codes:[String] = []
   
    struct Param:Codable {
        var name:String = ""
        var key:String = ""
        var value:String = ""
        static var _debug = Param(name: "均线", key:"ma" , value: "5")
    }
  

    static var _debug = Analyse(params: [Param._debug], name: "测试")
    
    enum CodingKeys: String, CodingKey {
        case params
        case name
        case des
        case begin
        case end
        case codes
    }
    
}

extension Analyse{
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        params = try container.decode([Analyse.Param].self, forKey: .params)
        name = try container.decode(String.self, forKey: .name)
        des = try container.decode(String.self, forKey: .name)
        let tbegin = try container.decodeIfPresent(String.self, forKey: .begin)
        begin = tbegin ?? "20160101"
        let tend = try container.decodeIfPresent(String.self, forKey: .end)
        begin = tend ?? ""
        
        let tcodes = try container.decodeIfPresent([String].self, forKey: .codes)
        codes = tcodes ?? ["000333.SZ"]
        
    }
}

