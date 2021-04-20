//
//  PageObservable.swift
//  apple
//
//  Created by admin on 2021/4/19.
//

import Foundation


public protocol StoreAlert: ObservableObject  {

    
    var isalert:Bool {get set}
    var alertData:TostError? {get set}
    func alert(error:Error?)
}


extension StoreAlert{
 
    func alert(error:Error?){
       
        guard error != nil else {
            return
        }
        let nserr = error! as NSError
        self.alertData = TostError(code: nserr.code, msg: nserr.domain, title: nil, level: .error)
        self.isalert = true
    }
}

