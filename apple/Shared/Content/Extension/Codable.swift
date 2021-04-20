//
//  DataRequest.swift
//  apple
//
//  Created by admin on 2021/4/19.
//

import Foundation
import Alamofire



extension DataRequest{
    
    open func responseModel<T>(_ type: T.Type, callback:@escaping (Result<T, Error>) ->  ()) where T : Codable{
        self.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                do{
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: value as Any, options: [])
                    let data = try JSONDecoder().decode(type.self, from: jsonData)
                    callback(.success(data))
                }
                catch {
                    callback(.failure(error))
                }
            case .failure(let error):
                print("\(error)")
                callback(.failure(error))
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

