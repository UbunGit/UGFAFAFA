//
//  ShareEdit.swift
//  Share
//
//  Created by admin on 2020/12/16.
//  Copyright © 2020 MBA. All rights reserved.
//

import Foundation
import SwiftUI
import Alamofire

class ShareEdit: ObservableObject, StoreAlert  {
    
    @Published var loading = false
    @Published var isalert:Bool = false
    @Published var alertData:APIError?
    
    @Published var share:Share = Share()
    
    var id:Int = 0
    
    func loadData()  {

        if( id != 0 ){
            self.loading = true
            
            AF.request("\(baseurl)/api/shares/detail",
                       method: .get,
                       parameters: ["id":id])
            { urlRequest in
                urlRequest.timeoutInterval = 5
            }
            .responseModel(Share.self) { [self]  (resule) in
                
                
                switch resule{
                case.success(let value):
                    self.share = value
                case.failure(let error):alert(error: error)
                }
                
                loading = false
                print(String.init(format: "store:\(share)"))
            }
            
            
        }else{
            //            share = Share()
        }
    }
    
}

/**
 api
 */

extension ShareEdit{
    
    //新增/修改数据
    func api_update()  {
        share.api_share(id: self.id)
            .responseModel(Share.self) { [self] (resule) in
                switch resule{
                case.success(let value):
                    self.share = value
                case.failure(let error):
                    alert(error: error)
                }
            }
    }
    
    /**
     获取详情
     */
    func api_shares_detail() {
        
        
    }
    
    func api_delete( finesh:@escaping ()->()){
        
        let url = "\(baseurl)/api/shares/delete"
        let parameters = ["id":id]
        AF.request(url, method: .get,parameters: parameters).responseModel([String:String].self) { [self](resule) in
            switch resule{
            case.success( _):finesh()
            case.failure(let error): alert(error: error)
            }
            
        }
    }
    
    
}


