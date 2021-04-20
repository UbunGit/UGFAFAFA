//
//  ShareDetailStore.swift
//  Share
//
//  Created by admin on 2020/12/16.
//  Copyright © 2020 MBA. All rights reserved.
//

import Foundation
import Alamofire

class ShareDetailStore: ObservableObject, StoreAlert  {

    @Published var loading = false
    
    @Published var isalert:Bool = false
    @Published var alertData:TostError?
    
    
    @Published var share:Share = Share(id: 0)
    @Published var fitterStore: [Store]?
  
    @Published var shizhi:Float = 0 // 市值
    @Published var profit:Float = 0 // 持仓收益
    @Published var profited:Float = 0 // 实现收益
    @Published var allprofit:Float = 0 // 全部收益
    @Published var percent:Float = 0 // 收益比例
    @Published var price:Float = 0.00 //股票价格

    var id:Int

    init(id:Int) {
        self.id = id
    }
    
    func reloadFitterStores(type:Int) {
        guard let tstore = share.stores else {
            return
        }
        if type==0 {
            fitterStore = tstore
        }else if (type == 1){
            fitterStore = tstore.filter({ (store) -> Bool in
                return store.state == 0 || store.state == nil
            })
            
        }else if (type == 2){
            fitterStore = tstore.filter({ (store) -> Bool in
                return store.state == 1
            })
        }
        
    }

    func loadData()  {
        
    }

    /**
     获取详情数据
     */
    func share(id:Int) {
        
        //        let issql = UserDefaults.standard.bool(forKey: "isSql")
        //        if issql {
        //            Share.db_share(id: id) { (error, resule) in
        //                if(error != nil){
        //                    print(error?.description as Any)
        //                    self.tostError = TostError.init(code: -1, msg: error?.description ?? "未知", title: "错误", level: .error)
        //                }else{
        //                    self.share = resule ?? Share.init()
        //                }
        //                self.loading = false
        //            }
        //        }else{
        //            Share.api_share(id: id) { (error, resule) in
        //                if(error != nil){
        //                    print(error?.description as Any)
        //                    self.tostError = TostError.init(code: -1, msg: error?.description ?? "未知", title: "错误", level: .error)
        //                }else{
        //                    self.share = resule ?? Share.init()
        //                }
        //                self.loading = false
        //            }
        //        }
        //
        //        self.needIn = (self.share.getInPrice() > Float(self.share.price) ?? MAXFLOAT)
        //        self.needOut = (self.share.getOutPrice() < Float(self.share.price) ?? MAXFLOAT)
        
    }
    
    /**新增/修改*/
    func update(finesh:@escaping  (Error?, Share?) ->  ()) {
        //        let issql = UserDefaults.standard.bool(forKey: "isSql")
        //        if issql {
        //            self.share.db_share(id: (self.share.id != 0) ? self.share.id : nil, finesh: finesh)
        //            
        //        }else{
        //            self.share.api_share(id: (self.share.id != 0) ? self.share.id : nil) { (error, resule) in
        //                if(error != nil){
        //                    self.tostError = TostError.init(code: -1, msg: error?.description ?? "未知", title: "错误", level: .error)
        //                }else{
        //                    self.share = resule ?? Share.init()
        //                }
        //                self.loading = false
        //            }
        //        }
    }
    
    func delete(finesh:@escaping  (NSError?) ->  ()) {
        
        //        let issql = UserDefaults.standard.bool(forKey: "isSql")
        //        if issql {
        //            self.share.db_delete(finesh: finesh)
        //        }else{
        //            self.share.api_delete(finesh: finesh)
        //        }
    }
    
    func updatePrice()  {
        if self.share.code.count>0  {
            AF.request("http://hq.sinajs.cn/list=\(self.share.code.lowercased())", method: .get)
                .responseString { (response) in
                    switch response.result {
                    case .success(let data):
                        let datas = data.split(separator: ",")
                        guard  datas.count>1  else {
                            print("获取股票信息失败")
                            return
                        }
                      
                        self.price = Float(datas[3]) ?? 0.00
                        self.shizhi =  Float(self.share.getAllNum(state: 0)) * self.price; //当前次仓总资产
                        self.percent  = (self.shizhi/self.share.getAllPrice(state: 0))*100
                        self.profit =  self.shizhi - self.share.getAllPrice(state: 0)
                        
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }

}

/**
 api
 */

extension ShareDetailStore{
    
    
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
    
    
}


