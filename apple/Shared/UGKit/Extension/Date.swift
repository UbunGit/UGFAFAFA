//
//  Date.swift
//  apple
//
//  Created by admin on 2021/3/30.
//

import Foundation

extension Date{
    func toString(dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: self)
        return date
    }
}

extension String{
    func toDate( dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> Date{
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: self)
        return date!
    }
}
