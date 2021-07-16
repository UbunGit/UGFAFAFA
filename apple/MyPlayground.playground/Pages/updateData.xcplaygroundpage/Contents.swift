//: [Previous](@previous)

import Foundation
import UGSwiftKit

func update(finesh:(_ finesh:BaseError?)->()){
    var werror:BaseError?
    let group = DispatchGroup()
    group.enter()
    updateStockBase { error in
        if error != nil {
            werror = error
        }
    }
    
    group.enter()
    updateETFBase { error in
        if error != nil {
            werror = error
        }
    }
   
    group.notify(queue: .main) {
        print("all requests come back")
//        finesh(werror)
    }

    
}
update { error in
    if error==nil {
        print("OK")
    }else{
        print("ERROR")
    }
}
