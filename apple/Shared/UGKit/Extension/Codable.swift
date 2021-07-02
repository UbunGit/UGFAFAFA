//
//  DataRequest.swift
//  apple
//
//  Created by admin on 2021/4/19.
//

import Foundation
import Alamofire
import UGSwiftKit

struct APIData<T:Codable>:Codable{
    var code:Int
    var message:String?
    var data:T?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(Int.self, forKey: .code)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        data = try container.decodeIfPresent(T.self, forKey: .data)

        
    }
}

extension DataRequest{
    
    open func responseModel<T>(_ type: T.Type, callback:@escaping (Result<T, APIError>) ->  ()) where T : Codable{
        
        self.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                do{
                    print(value)
                    let apidata = try JSONDecoder().decode(APIData<T>.self, from: value)
                 
                    if apidata.code == 0 {
                        callback(.success(apidata.data!))
                    }else{
                        callback(.failure(APIError(code: apidata.code, msg: apidata.message ?? "unkown error")))
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

