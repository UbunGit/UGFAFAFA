//
//  File.swift
//  
//
//  Created by admin on 2021/5/11.
//

import Foundation

public struct Analyse:Codable{
    public var name:String = ""
    public var des:String?
    public var parameter:[Param] = []
    
    public init() {}
    
    public  struct Param:Codable {
        
        var name:String = ""
        var des:String?
        var value:String = ""
        
        public init() {}
    }
}

public struct ShareBase:Codable {
    var name:String = ""
    var code:String = ""
    var industry:String = ""
}
