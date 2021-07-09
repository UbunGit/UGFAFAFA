//
//  Cerebro.swift
//  apple
//  交易中心
//  Created by admin on 2021/7/9.
//

import Foundation

public class Cerebro {
    
    var loglevel = true // 是否打印日志
    var cash:Float
    var balance:Float
    
    private var bsline:[BSModen] = []
    private var zoneLine:[ZoneModen] = []
    
    public init(cash:Float=10000) {
        self.cash = 10000
        balance = cash
    }

    func buy(code:String,
             date:St,
             price:Float,
             count:Int,
             free:(()->(Float))? = nil
    ) -> Bool {
        let money = price * Float(count) + ((free == nil) ? 0.0 : free!())
        guard cash >= money else {
            loging("余额不足")
            return false
        }
        var bspoint = BSModen()
   
        bspoint.code = code
        date = date
        cacheId = 0
        count = 0
        price = 0
        free = 0
        type = 0
        
        

        return false
    }
    func seller() -> Bool {
        return false
    }
    
    
}

public extension Cerebro{
    func loging(_ msg:Any) {
        if loglevel {
            print("Cerebro:\(msg)")
        }
    }
}
