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


    
public func lib_ma(_ ma:Int, closes:[Double]) -> [Double] {
    
    closes.enumerated().map { (index,item) in
        let idx = index+1
        let begin = (idx-ma >= 0) ? idx-ma : 0
        
        return closes[begin..<idx].reduce(0.0) { $0 + $1 }/Double(idx-begin)
    }
}







