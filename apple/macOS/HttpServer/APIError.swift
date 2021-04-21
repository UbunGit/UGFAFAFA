//
//  HttpError.swift
//  apple
//
//  Created by admin on 2021/4/21.
//

import Foundation
import PerfectHTTP
import PerfectHTTPServer

struct APIError:Error,Codable {
    
    var code:Int
    var msg:String
    init(code:Int,msg:String) {
        self.code = code
        self.msg = msg
    }
}

extension HttpServer{
    
    func apiCompleted<T:Codable>(response:HTTPResponse, result: T?, error:APIError?){
        
        response.setHeader(.contentType, value: "application/json")
        if error != nil {
            response.completed(status:.custom(code: error!.code, message: error!.msg))
        }else{
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(result)
            guard let json = String(data: jsonData!, encoding: .utf8) else {
                response.appendBody(string: "")
                return
            }
            response.appendBody(string: json)
            response.completed()
        }
       
    }
}




