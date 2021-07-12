//: [Previous](@previous)
import PlaygroundSupport
import Foundation
import Alamofire
import apple

UserDefaults.standard.set("/Users/admin/Documents/github/UGFAFAFA/data/sqlite/sqlite.db", forKey: "dbfile")

//: 获取股票列表

//AF.api_store_basic { result in
//    switch result {
//    case .failure(let error):
//        print(error)
//    case .success(let value):
//
//       try? StockBasic.insert(datas: value, keys: StockBasic.sqlKeys)
//        print("scress")
//    }
//    PlaygroundPage.current.finishExecution()
//}

//: [Next](@next)
