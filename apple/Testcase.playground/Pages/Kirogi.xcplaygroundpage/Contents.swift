//: [Previous](@previous)

//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport


let testdata:[Daily] = [
    Daily.init(),
    Daily.init(),
    Daily.init(),
    Daily.init(),
    Daily.init(),
    Daily.init(),
    Daily.init(),
    Daily.init(),
    Daily.init(),
    Daily.init()
]



/*:
 鸿雁 根据ma均线相交计算买卖时机
 */
struct Kirogi:SchemeProtocol {
    
    typealias T = Daily
    
    var datas: [Daily]
    
    var ma:[Int] = [5,10]
  
    // 计算信号量
    func signal(index:Int) -> Float{
        return 0
    }
    
    // 交易
    func transaction(index:Int) -> Any{
        return 0
    }
}




public func signal_values(closes:[Double], ma:[Int]) -> [Double] {
    
    // 计算ma
    let ma_values = ma.map {lib_ma($0, closes: closes)}
    // 计算ma 差值比
    let ma_values_v = closes.enumerated().map { (index, item) -> Double in
        let ma0 = ma_values[0][index]
        let ma1  = ma_values[1][index]
        return (ma0 - ma1)/ma1
    }
    let absmax = abs(ma_values_v.max()!)
    let asbmin = abs(ma_values_v.min()!)
    let z = max(absmax, asbmin)
    // 扁平化 -1～1
    
    let rz = ma_values_v.map {$0/z}

    return rz
  
}
func squalsignal(signal:[Double]) -> [Double]{
    
    signal.enumerated().map {(index,item) -> Double in
        let  tsin = item>0 ? 1.0 : -1.0
        if index>1 {
            if(tsin>0){
                return (item > signal[index-1]) ? 1*tsin : 0.5*tsin
            }else{
                return (item > signal[index-1]) ? 0.5*tsin : 1*tsin
            }
        }else{
            return 0
        }
    }
}

let tda:[Double] = (0..<100).map { sin(Double($0)*0.1) + 10  }

var tsin = signal_values(closes: tda, ma: [5,10])
let ssin = squalsignal(signal: tsin)
let ma5 = lib_ma(5, closes: tda)
let ma10 = lib_ma(10, closes: tda)
let cdatas = [tda,tsin,ma5,ma10,ssin]
PlaygroundPage.current.setLiveView(SFLineChartView(data:cdatas))
//
//let closes:[Double] = testdata.map { Double($0.close)}
//let kirogi = Kirogi(datas:testdata)
//let signal = signal_values(closes: closes, ma:kirogi.ma)
//print(sin)

PlaygroundPage.current.needsIndefiniteExecution = true


