//
//  DataRequest.swift
//  apple
//
//  Created by admin on 2021/4/19.
//

import Foundation
import Alamofire

struct APIData<T:Codable>:Codable{
    var code:Int
    var message:String?
    var data:T?
   
    
}

extension DataRequest{
    
    open func responseModel<T>(_ type: T.Type, callback:@escaping (Result<T, APIError>) ->  ()) where T : Codable{
        
        self.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                do{

                    let jsonData = try JSONSerialization.data(withJSONObject: value as Any, options: [])
                    let apiData = try JSONDecoder().decode(APIData<T>.self, from: jsonData)
                    if apiData.code == 0 {
                        callback(.success(apiData.data!))
                    }else{
                        callback(.failure(APIError(code: apiData.code, msg: apiData.message ?? "unkown error")))
                    }
                }
                catch {
                    print("🐬 \(error)")
                    callback(.failure(APIError(code: -100, msg: "json error")))
                }
            case .failure(let error):
                print("🐬 \(error)")
                callback(.failure(APIError(code: -200, msg: "http error")))
            }
        }
    }
}



extension Encodable{
    
    func toParameters() throws -> Parameters {
        let paramedata = try? JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: paramedata!, options: .mutableContainers) as! Parameters
    }
}

