//
//  Analyse.swift
//  apple
//
//  Created by admin on 2021/5/27.
//


struct Analyse:Codable {
    
    var parameter:[Parameter] = []
    var name:String = ""
    var des:String?
    
    var begin:String = ""
    var end:String = ""
    var codes:[String] = []
    var result:String = ""
    var createTime:String = ""
    var changeTime:String = ""
   
    struct Parameter:Codable {
        var name:String = ""
        var key:String = ""
        var value:String = ""
        static var _debug = Parameter(name: "均线", key:"ma" , value: "5")
        
        enum CodingKeys: String, CodingKey {
            case name
            case key
            case value
            
        }
    }
  

    static var _debug = Analyse(parameter: [Parameter._debug], name: "测试")
    
    enum CodingKeys: String, CodingKey {
        case parameter
        case name
        case des
        case begin
        case end
        case codes
        case createTime
        case changeTime
        
    }
    
}

extension Analyse{
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        parameter = try container.decode([Analyse.Parameter].self, forKey: .parameter)
        name = try container.decode(String.self, forKey: .name)
        des = try container.decode(String.self, forKey: .name)
        let tbegin = try container.decodeIfPresent(String.self, forKey: .begin)
        begin = tbegin ?? "20160101"
        let tend = try container.decodeIfPresent(String.self, forKey: .end)
        end = tend ?? ""
        
        let tcodes = try container.decodeIfPresent([String].self, forKey: .codes)
        codes = tcodes ?? ["000333.SZ"]
        
        let tcreateTime = try container.decodeIfPresent(String.self, forKey: .createTime)
        createTime = tcreateTime ?? ""
        
        let tchangeTime = try container.decodeIfPresent(String.self, forKey: .changeTime)
        changeTime = tchangeTime ?? ""
        
    }
}

extension Analyse.Parameter{
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let tname = try container.decodeIfPresent(String.self, forKey: .name)
        name = tname ?? ""
        
        let tkey = try container.decodeIfPresent(String.self, forKey: .key)
        key = tkey ?? ""
        let tvalue = try container.decodeIfPresent(String.self, forKey: .value)
        value = tvalue ?? ""
  
    }
}

