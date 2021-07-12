//
//  Signal.swift
//  apple
//
//  Created by admin on 2021/7/9.
//

import Foundation


// 方案
protocol SchemeProtocol{
    
    associatedtype T:Any

    var datas:[T] { get set }
    
    // 计算信号量
    func signal(index:Int) -> Float
    
    // 交易
    func transaction(index:Int) -> Any
}

protocol Operationsable {
    
    static func /(lhs: Self, rhs: Self) -> Self

    func doubleValue() -> Double
}

extension Double: Operationsable {
    func doubleValue() -> Double{
        Double(self)
    }
  
}
extension Float: Operationsable {
    func doubleValue() -> Double{
        Double(self)
    }
}
extension Int: Operationsable {
    func doubleValue() -> Double{
        Double(self)
    }
}

/*:
 ma
 */
func lib_ma<T>(_ ma:Int, closes:[T]) -> [Double] where T : Comparable, T : SignedNumeric, T : Operationsable {
    
    closes.enumerated().map { (index,item) in
        let idx = index+1
        let begin = (idx-ma >= 0) ? idx-ma : 0
        let c = (idx-begin).doubleValue()
        
        return closes[begin..<idx].reduce(0.0) {
            $0.doubleValue() + $1.doubleValue()
        }/c
    }
}

/*:
 归一化 0~1
 */
func lib_scaler<T>(_ x: [T]) -> [Double] where T : Comparable, T : SignedNumeric, T : Operationsable {
    
    func scaler(max:Double,min:Double, num:Double) -> Double{
        let c = num-min
        let v = max-min
        return c/v
    }

    let max = x.max()!.doubleValue()
    let min = x.min()!.doubleValue()
  
    let r =  x.map {
        scaler(max: max, min:min, num: $0.doubleValue()) }
    return r
}







