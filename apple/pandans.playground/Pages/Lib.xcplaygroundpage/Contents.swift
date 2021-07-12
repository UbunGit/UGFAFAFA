//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

protocol Operationsable {
    
    static func /(lhs: Self, rhs: Self) -> Self

    func todouble() -> Double
}

extension Double: Operationsable {
    func todouble() -> Double{
        Double(self)
    }
  
}
extension Float: Operationsable {
    func todouble() -> Double{
        Double(self)
    }
}
extension Int: Operationsable {
    func todouble() -> Double{
        Double(self)
    }
}



// 归一化 0~1
func lib_scaler<T>(_ x: [T]) -> [Double] where T : Comparable, T : SignedNumeric, T : Operationsable {
    
    func scaler(max:Double,min:Double, num:Double) -> Double{
        let c = num-min
        let v = max-min
        return c/v
    }
    Double()
    let max = x.max()!
    let min = x.min()!
  
    let r =  x.map {
        scaler(max: max, min:min, num: $0.todouble()) }
    return r
}

let intTest:[Int] = (50...100).map { $0}
lib_scaler(intTest)

let floatTest:[Float] = (0...100).map { Float($0)}
lib_scaler(floatTest)

let doubleTest:[Double] = (0...100).map { Double($0)}
lib_scaler(doubleTest)



