//
//  Signal.swift
//  apple
//
//  Created by admin on 2021/7/9.
//

import Foundation

protocol SignalProtocol{
    
    associatedtype T:Any
    func signal(datas:[T], handle:(T)->()) -> [Float]
}

extension SignalProtocol{
    
    func signal(datas:[T], handle:(T)->(Float)) -> [Float]{
        datas.map { handle( $0 )}
    }
}

