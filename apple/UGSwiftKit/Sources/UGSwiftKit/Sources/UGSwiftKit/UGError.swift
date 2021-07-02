//
//  HttpError.swift
//  apple
//
//  Created by admin on 2021/4/21.
//

import Foundation

public struct BaseError: Error {
    
    public var code:Int
    public var title:String?
    public var msg:String
    
    public init(code:Int,msg:String) {
        self.code = code
        self.msg = msg
    }
}

public struct APIError: Error {
    
    public var code:Int
    public var title:String?
    public var msg:String
    
    public init(code:Int,msg:String) {
        self.code = code
        self.msg = msg
    }
}








