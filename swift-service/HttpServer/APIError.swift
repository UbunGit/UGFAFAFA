//
//  HttpError.swift
//  apple
//
//  Created by admin on 2021/4/21.
//

import Foundation

public struct APIError: Error {
    
    var code:Int
    var title:String?
    var msg:String
    
    init(code:Int,msg:String) {
        self.code = code
        self.msg = msg
    }
}






