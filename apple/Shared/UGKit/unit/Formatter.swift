//
//  Formatter.swift
//  apple
//
//  Created by admin on 2021/4/3.
//

import Foundation


class StringLenFormatter: Formatter {
    var maxlen = 50
    required init?(maxlen: Int) {
        super.init()
        self.maxlen = maxlen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        if(string.count>maxlen){
            error?.pointee = "max leng "
            return false
        }
        print(error?.pointee)
        obj?.pointee = String(string.prefix(maxlen)) as AnyObject
        
        return true
    }
    
    override func string(for obj: Any?) -> String? {
        if obj == nil { return nil }
        if let str = (obj as? String) {
            let endstr =  String(str.prefix(maxlen))
            return endstr
        }
        return nil
      
       
    }
}

