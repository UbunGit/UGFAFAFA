//
//  File.swift
//  
//
//  Created by admin on 2021/4/29.
//

import Foundation
import PythonKit

public protocol DataManageProtocol{
    
}
extension DataManageProtocol{
    
    /*:
     更新时间判断
     0: 如果没有缓存记录 return true
     1: 上次下载时间晚于当今天16:00 return false
     2: 现在时间早于16:00 上次下载时间晚于昨天16:00 return false
     */
    public static func needDownload(_ key:String) -> Bool{
       
        let now = Date()
        let laseDownDate = try? DataCache.value(of: key)?.toDate()
        let tody16 = now.toString("yyyy-MM-dd")?.appending(" 16:00:00").toDate()
        let yestody16 = Date(timeInterval: -24*60*60, since: tody16!)
        if laseDownDate != nil {
        
            // date1.compare(date2) == .orderedAscending date1 < date2
            if tody16!.compare(laseDownDate!) == .orderedAscending  {
                return false
            }else if now.compare(tody16!) == .orderedAscending && yestody16.compare(laseDownDate!) == .orderedAscending{
                return false
            }
        }
        return true
        
    }
    

    
}
