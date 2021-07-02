//
//  ArchiveSharesPageStore.swift
//  Share
//
//  Created by admin on 2020/12/16.
//  Copyright © 2020 MBA. All rights reserved.
//

import SwiftUI
import Alamofire
import UGSwiftKit

class SharesList: ObservableObject, StoreAlert{
    
    
    @Published var loading = false
    @Published var isalert:Bool = false
    @Published var alertData:APIError?
    
    @Published var shares:[Share]?
    @Published var searchText:String=""
    {
        didSet {
            if searchText.count > 2 && oldValue.count <= 2 {
                searchText = oldValue
            }
        }
    }
    /**
     获取列表
     */
    func update() {
        self.loading = true
        let url = "\(baseurl)/api/shares/list"
        let parameters = ["page":1,"content":100]
        AF.request(url, method: .get,parameters: parameters){ urlRequest in
            urlRequest.timeoutInterval = 5
        }.responseModel(UGPage<[Share]>.self) { [self] (resule) in
            switch resule{
            case.success( let results):
                self.shares = results.datas
            case.failure(let error): alert(error: error)
            }
            self.loading = false
        }
    }
    
    
}
