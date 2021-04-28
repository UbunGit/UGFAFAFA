//
//  File.swift
//  
//
//  Created by admin on 2021/4/28.
//

import Foundation

extension Date{
    
//    public static var locDate:Date{
        
//        let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//            let localDate = dateFormatter.date(from: Date())
//            return localDate
//    }
    public func toString(_ formatter:String = "yyyy-MM-dd HH:mm:ss") -> String? {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = formatter
        let str = dateformatter.string(from: self)
        return str
    }
}

extension String{
    
    public func toDate(_ formatter:String = "yyyy-MM-dd HH:mm:ss") -> Date?{
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = formatter
        let date = dateformatter.date(from: self)
        return date
    }
}
