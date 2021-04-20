//
//  ShareEdit.swift
//  Share
//
//  Created by admin on 2020/12/16.
//  Copyright © 2020 MBA. All rights reserved.
//

import Foundation
import Alamofire

class ShareEdit: ObservableObject, StoreAlert  {
    
    
    @Published var loading = false
    
    @Published var isalert:Bool = false
    @Published var alertData:TostError?
  
    @Published var share:Share = Share._shares[0]
  
    
    var id:Int
    
    init(id:Int) {
        self.id = id
    }

    func loadData()  {
        api_shares_detail()
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
        let url = "\(baseurl)/api/shares/detail"
        let parameters = ["id":id]
        AF.request(url, method: .get,parameters: parameters){ urlRequest in
            urlRequest.timeoutInterval = 5
        }.responseModel(Share.self) { [self] (resule) in
            switch resule{
            case.success(let value):
                share = value
            case.failure(let error):
                alert(error: error)
            }
            
        }
    }
    
    
}


