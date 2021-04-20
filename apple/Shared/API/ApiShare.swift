//
//  Share.swift
//  apple
//
//  Created by admin on 2021/3/30.
//

import Foundation
import Alamofire



extension Share{
//    /**
//     获取列表
//     */
//    static func stores(finesh:@escaping  (NSError?, [Store]?) ->  ()) {
//
//        let issql = UserDefaults.standard.bool(forKey: "isSql")
//        if issql {
//            Store.db_stores(finesh: finesh)
//        }else{
//            Store.db_stores(finesh: finesh)
//        }
//    }
//
//    /**新增/修改*/
//    func store(finesh:@escaping  (NSError?, Store?) ->  ()) {
//
//        let issql = UserDefaults.standard.bool(forKey: "isSql")
//        if issql {
//            self.db_store(id: (id != 0) ? id : nil, finesh: finesh)
//        }else{
//            self.api_store(id: (id != 0) ? id : nil, finesh: finesh)
//        }
//    }
//
//    func delete(finesh:@escaping  (NSError?) ->  ()) {
//
//        let issql = UserDefaults.standard.bool(forKey: "isSql")
//        if issql {
//            self.db_delete(id:id,finesh: finesh)
//        }else{
//            self.api_delete(id:id,finesh: finesh)
//        }
//    }
}

// MARK: HTTP
extension Share{
    
    static func api_shares_list(finesh:@escaping  (NSError?, UGPage<[Share]?>?) ->  ()){
        
        let url = "\(baseurl)/api/shares/list"
        let parameters = ["page":1,"content":100]
        AF.request(url, method: .get, parameters: parameters){ urlRequest in
            urlRequest.timeoutInterval = 5
        }
        .responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: value as Any, options: [])
                    let shares = try JSONDecoder().decode(UGPage<[Share]?>.self, from: jsonData)
                    finesh(nil, shares)
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
    
    static func api_shares_detail(id:Int, finesh:@escaping  (NSError?, Share?) ->  ()){
        
        let url = "\(baseurl)/api/shares/detail"
        let parameters = ["id":id]
        AF.request(url, method: .get,parameters: parameters){ urlRequest in
            urlRequest.timeoutInterval = 5
        }.responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: value as Any, options: [])
                    let share = try JSONDecoder().decode(Share.self, from: jsonData)
                    finesh(nil, share)
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
    
    /**新增/修改*/
    func api_share(id:Int?)->DataRequest{
        
        var url = "\(baseurl)/api/shares"
        if (id != 0) {
            url.append("/\(id!)")
        }
        var parame = try? self.toParameters()
        parame?["stores"] = stores
        
        return AF.request(url, method:  (id != 0) ? .put : .post, parameters: parame){ urlRequest in
            urlRequest.timeoutInterval = 5
        }
        
    }
    
    func api_delete(finesh:@escaping  (NSError?) ->  ()) {
        let url = "\(baseurl)/shares/\(id)"
        AF.request(url, method: .delete){ urlRequest in
            urlRequest.timeoutInterval = 5
        }.responseJSON { (response) in
            
            switch response.result {
            case .success(let _):
                
                finesh(nil)
                
            case .failure(let error):
                print("error")
                finesh(NSError.init(domain: error.localizedDescription , code: -1, userInfo: nil))
                
            }
        }
    }
    
  
    //    0：”大秦铁路”，股票名字；
    //    1：”27.55″，今日开盘价；
    //    2：”27.25″，昨日收盘价；
    //    3：”26.91″，当前价格；
    //    4：”27.55″，今日最高价；
    //    5：”26.20″，今日最低价；
    //    6：”26.91″，竞买价，即“买一”报价；
    //    7：”26.92″，竞卖价，即“卖一”报价；
    //    8：”22114263″，成交的股票数，由于股票交易以一百股为基本单位，所以在使用时，通常把该值除以一百；
    //    9：”589824680″，成交金额，单位为“元”，为了一目了然，通常以“万元”为成交金额的单位，所以通常把该值除以一万；
    //    10：”4695″，“买一”申请4695股，即47手；
    //    11：”26.91″，“买一”报价；
    //    12：”57590″，“买二”
    //    13：”26.90″，“买二”
    //    14：”14700″，“买三”
    //    15：”26.89″，“买三”
    //    16：”14300″，“买四”
    //    17：”26.88″，“买四”
    //    18：”15100″，“买五”
    //    19：”26.87″，“买五”
    //    20：”3100″，“卖一”申报3100股，即31手；
    //    21：”26.92″，“卖一”报价
    //    (22, 23), (24, 25), (26,27), (28, 29)分别为“卖二”至“卖四的情况”
    //    30：”2008-01-11″，日期；
    //    31：”15:05:32″，时间；
}



