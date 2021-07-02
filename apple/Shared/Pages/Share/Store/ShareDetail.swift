//
//  ShareDetailStore.swift
//  Share
//
//  Created by admin on 2020/12/16.
//  Copyright © 2020 MBA. All rights reserved.
//

import Foundation
import Alamofire
import UGSwiftKit

class ShareDetail: ObservableObject, StoreAlert  {

    @Published var loading = false
    @Published var isalert:Bool = false
    @Published var alertData:APIError?
    
    
    @Published var share:Share = Share._shares[0]
    @Published var fitterStore: [Store]?

    // 收益比例
    var percent:Float{
        (self.shizhi/self.share.getAllPrice(state: 0))*100
    }
    @Published var price:Float = 0.00 //股票价格
    
    // 市值
    var shizhi:Float{
        Float(self.share.getAllNum(state: 0)) * self.price;
    }
    // 持仓收益
    var profit:Float{
        self.shizhi - self.share.getAllPrice(state: 0)
    }
    // 实现收益
    var profited:Float{
        self.share.getIncome()
    }

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
        
        loading = true
        let url = "\(baseurl)/api/shares/detail"
        let parameters = ["id":id]
        AF.request(url, method: .get,parameters: parameters){ urlRequest in
            urlRequest.timeoutInterval = 5
        }.responseModel(Share.self) { [self] (resule) in

                loading = false
                switch resule{
                case.success(let value):
                    self.share = value
                    self.updatePrice()
                    self .reloadFitterStores(type: 0)
                case.failure(let error):
                    alert(error: error)
                }
        }
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
//                        self.shizhi =  Float(self.share.getAllNum(state: 0)) * self.price; //当前次仓总资产
//                        self.percent  = (self.shizhi/self.share.getAllPrice(state: 0))*100
//                        self.profit =  self.shizhi - self.share.getAllPrice(state: 0)
                        
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

extension ShareDetail{
    
    
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

extension Share{

    // 根据状态获取持仓数量
    func getAllNum(state:Int?) -> Int {
        guard self.stores != nil else {
            return 0
        }
        var t_store = self.stores
        if (state != nil) {
            t_store = t_store!.filter { Int($0.state ?? 0) == state}
        }
        var num = 0
    
        for item in t_store! {
            if item.num>0 {
                num = num+item.num
            }
        }
        return num
    }
    /**
     获取对应状态当前成本总和
     */
    func getAllPrice(state:Int?) -> Float {
        
        guard self.stores != nil else {
            return 0
        }
        var t_store = self.stores
        if (state != nil) {
            t_store = t_store!.filter { Int($0.state ?? 0) == state}
        }
        var price:Float = 0
        for item in t_store! {
            price = price+(item.price*Float(item.num))
        }
        return price
    }
    
    // 计算买入价
    func getInPrice()  -> Float{
        guard let store = self.stores else {
            return 0
        }
        var inprice:Float = store[0].price
        for item in store {
            if item.num>0 {
                inprice = min(item.price, inprice)
            }
        }
        return inprice*(Float(ratioIn) ?? 0.95)
    }
    
    // 计算卖出价
    func getOutPrice() -> Float {
        guard let stores = self.stores else {
            return 0
        }
        var inprice:Float = stores[0].price
        for item in stores {
            if item.num>0 {
                inprice = min(item.price, inprice)
            }
        }
        return inprice*(Float(ratioOut) ?? 1.05)
    }
    
    // 获取成本最低的store
    func getminPriceStore()  -> Store?{
        guard let stores = self.stores else {
            return nil
        }
        var store = stores[0]
        var inprice:Float = stores[0].price
        for item in stores {
            if item.num>0 {
                if item.price < inprice {
                    inprice = item.price
                    store = item;
                }
            }
        }
        return store
    }
    
    /**
     获取收益
     */
    func getIncome() -> Float {
        guard self.stores != nil else {
            return 0
        }
        var t_store = self.stores
         
        t_store = t_store!.filter { Int($0.state ?? 0) == 1}
     
        var income:Float = 0
        for store in t_store! {
            
            let outprice:Float = store.outprice ?? 0.00
            let price:Float = store.price
            let fee:Float = store.fee ?? 0.00
            income = income + ((outprice - price) * Float(store.num))-fee
            
        }
        return income
    }
    
    
}


