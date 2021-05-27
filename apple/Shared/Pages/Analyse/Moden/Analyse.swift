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
    
    struct Param:Codable {
        var name:String = ""
        var key:String = ""
        var value:String = ""
        
        static var _debug = Param(name: "均线", key:"ma" , value: "5")
    }
    
    static var _debug = Analyse(params: [Param._debug], name: "测试")
    
}
