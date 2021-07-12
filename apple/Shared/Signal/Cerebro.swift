//
//  Cerebro.swift
//  apple
//  交易中心
//  Created by admin on 2021/7/9.
//

import Foundation

public class Cerebro {
  
    public class BSLine {
        public var code:String
        public var bDate:Date
        public var sDate:Date?
        public var bPrice:Double
        public var sPrice:Double?
        public var count:Int
        public var bFree:Double
        public var sFree:Double?
        
    
        init(code: String,
             bDate: Date,
             sDate: Date?,
             bPrice: Double,
             sPrice: Double?,
             count: Int,
             bFree: Double,
             sFree: Double?) {
            
            self.code = code
            self.count = count
            self.bDate = bDate
            self.sDate = sDate
            self.bPrice = bPrice
            self.sPrice = sPrice
            self.count = count
            self.bFree = bFree
            self.sFree = sFree
        }
    }
    
    public var loglevel = true // 是否打印日志
    public var cash:Double
    public var balance:Double
    
    private var bslines:[BSLine] = []
  
    
    public init(cash:Double=10000) {
        self.cash = 10000
        balance = cash
    }

    public func buy(
        code:String,
        date:Date,
        price:Double,
        count:Int,
        free:((Double)->(Double))? = nil
    ) -> Bool {
        
        let money:Double = price * Double(count)
        let nfree:Double = Double((free == nil) ? 0.0 : free!(money))
        
        guard (cash >= money) else {
            loging("余额不足")
            return false
        }
        bslines.append(BSLine(
                        code: code,
                        bDate: date,
                        sDate: nil,
                        bPrice: price,
                        sPrice: nil,
                        count: count,
                        bFree: nfree,
                        sFree: nil
        ))
        cash = cash - money - nfree
        return true
    }
    
    public func seller(
        code:String,
        price:Double,
        date:Date,
        free:((Double)->(Double))? = nil) -> Bool
    {
        let allcount = allcount(code: code)
        if allcount <= 0 {
            loging("持仓不足")
            return false
        }
        guard let minline = minimumbs(code: code) else {
            loging("无持仓")
            return false
        }
        let money = (Double(minline.count) * price)
        let nfree:Double = Double((free == nil) ? 0.0 : free!(money))
        minline.sDate = date
        minline.sPrice = price
        minline.sFree = nfree
        cash = cash + money - nfree
        return true
    }
    
    
}

extension Cerebro{
    /// 获取最低成本
    public func minimumbs(code:String) -> BSLine? {
        bslines.filter { $0.sDate == nil }.min { $0.bPrice < $1.bPrice }
    }
    /// 获取持仓
    public func allcount(code:String) -> Int {
        return bslines.filter { $0.sDate == nil }.reduce(0){ $0 + $1.count }
    }
}

public extension Cerebro{
    func loging(_ msg:Any) {
        if loglevel {
            print("Cerebro:\(msg)")
        }
    }
}
