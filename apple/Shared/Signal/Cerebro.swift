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

    func buy(code:String, price:Float, count:Int, free:(()->(Float))? = nil) -> Bool {
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
