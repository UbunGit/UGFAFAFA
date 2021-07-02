//
//  PageObservable.swift
//  apple
//
//  Created by admin on 2021/4/19.
//

import Foundation
import UGSwiftKit

public protocol StoreAlert: ObservableObject  {

    var isalert:Bool {get set}
    var alertData: APIError? {get set}
    
    func alert(error:APIError?)
}


extension StoreAlert{
 
    func alert(error:APIError?){
       
        guard error != nil else {
            self.alertData = APIError(code: -1, msg: "--")
            self.isalert = true
            return
        }
        let nserr = error! 
        self.alertData?.code = nserr.code
        self.alertData?.msg = nserr.msg
        self.isalert = true
    }
}

