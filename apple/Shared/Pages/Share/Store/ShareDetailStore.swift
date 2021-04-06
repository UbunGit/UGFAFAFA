//
//  ShareDetailStore.swift
//  Share
//
//  Created by admin on 2020/12/16.
//  Copyright © 2020 MBA. All rights reserved.
//

import Foundation
import Alamofire

class ShareDetailStore: ObservableObject {
    
    @Published var share:Share = Share._shares[0]
    @Published var fitterStore: [Store]?
    @Published var needIn:Bool = false
    @Published var needOut:Bool = false
    @Published var shizhi:Float = 0
    @Published var percent:Float = 0
    @Published var price:Float = 8.00
    @Published var loading = false
    @Published var id:Int
    
    @Published var tostError:TostError?
    init(id:Int) {
        self.id = id
    }
    
    func reloadFitterStores(type:Int) {
        if type==0 {
            fitterStore = share.stores
        }else if (type == 1){
            fitterStore = share.stores?.filter({ (store) -> Bool in
                return store.state == 0 || store.state == nil
            })
            
        }else if (type == 2){
            fitterStore = share.stores?.filter({ (store) -> Bool in
                return store.state == 1
            })
        }
        
    }
    
    
    /**
     更新store
     */
    func update()  {
        
        guard self.id > 0 else {
            return
        }
        Share.api_shares_detail(id: self.id) { (error, resule) in
            if(error != nil){
                print(error?.description as Any)
                self.tostError = TostError.init(code: -1, msg: error?.description ?? "未知", title: "错误", level: .error)
            }else{
                self.share = resule!
                self.share.stores?.sort(by: { $0.id > $1.id})
                self.reloadFitterStores(type: 0)
                self.updatePrice()
                //                    self.shizhi = Float(self.share.getAllNum()) * (Float(self.share.price) ?? 0.00)
                if self.share.getAllPrice() > 0 {
                    self.percent  = (self.shizhi/self.share.getAllPrice())*100
                }
                //                    self.price  = Float(self.share.price) ?? 0.00
            }
            self.loading = false
        }
        
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
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }
    
    
    
}

