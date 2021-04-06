//
//  C_Store.swift
//  apple
//
//  Created by admin on 2021/3/30.
//

import Foundation
import Alamofire

/**
 api
 */
extension Store{
    
    static func api_stores_list(finesh:@escaping  (NSError?, [Store]?) ->  ()){
        
        let url = "\(baseurl)/api/shares/list"
        let parameters = ["_start":0,"_limit":10]
        AF.request(url, method: .get, parameters: parameters){ urlRequest in
            urlRequest.timeoutInterval = 5
        }.responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: value as Any, options: [])
                    let stores = try JSONDecoder().decode([Store].self, from: jsonData)
                    finesh(nil, stores)
                }
                catch {
                    finesh(error as NSError, nil)
                }
                
                
            case .failure(let error):
                print("error")
                finesh(NSError.init(domain: error.localizedDescription , code: -1, userInfo: nil),nil)
                
            }
        }
    }
    
    func api_store(id:Int?,finesh:@escaping  (NSError?, Store?) ->  ()) {
        var url = "\(baseurl)/stores"
        if (id != 0) {
            url.append("/\(id!)")
        }
        
        let paramedata = try? JSONEncoder().encode(self)
        let parameters = try? JSONSerialization.jsonObject(with: paramedata!, options: .mutableContainers)
        print(parameters as Any)
        AF.request(url, method: (id != 0) ? .put : .post, parameters: parameters as? Parameters){ urlRequest in
            urlRequest.timeoutInterval = 5
        }.responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: value as Any, options: [])
                    let store = try JSONDecoder().decode(Store.self, from: jsonData)
                    finesh(nil, store)
                }
                catch {
                    finesh(error as NSError, nil)
                }
            case .failure(let error):
              
                finesh(NSError.init(domain: error.localizedDescription , code: -1, userInfo: nil),nil)
            
            }
        }
    }
    
    /**
     删除持仓内容
     */
    func api_delete(id:Int, finesh:@escaping  (NSError?) ->  ())  {
        let url = "\(baseurl)/stores/\(id)"
  
        AF.request(url, method: .delete){ urlRequest in
            urlRequest.timeoutInterval = 5
        }.responseJSON { (response) in
            
            switch response.result {
            case .success( _):
                
                finesh(nil)
                
            case .failure(let error):
                
                finesh(NSError.init(domain: error.localizedDescription , code: -1, userInfo: nil))
                
            }
        }
    }
}
