//: [Previous](@previous)

import Foundation
import apple

//: 归一化 0～1
let intTest:[Int] = (50...100).map { $0}
lib_scaler(intTest)

let floatTest:[Float] = (0...100).map { Float($0)}
lib_scaler(floatTest)

let doubleTest:[Double] = (0...100).map { Double($0)}
lib_scaler(doubleTest)
//:   ma
public let testdata:[Float] = (0...100).map{Float($0)}
let matest = lib_ma(5, closes: testdata)
print(matest)

