//: [Previous](@previous)

import Foundation
import UGSwiftKit
import PlaygroundSupport

func update(finesh:@escaping (_ finesh:BaseError?)->()){
    var werror:BaseError?
    let group = DispatchGroup()
    group.enter()
    updateStockBase { error in
        if error != nil {
            werror = error
        }
        group.leave()
    }
    
    group.enter()
    updateETFBase { error in
        if error != nil {
            werror = error
        }
        group.leave()
    }
   
    group.notify(queue: .main) {
        print("all requests come back")
        finesh(werror)
    }

    
}
update { error in
    if error==nil {
        print("OK")
    }else{
        print(error)
    }
    PlaygroundPage.current.needsIndefiniteExecution = true
}
