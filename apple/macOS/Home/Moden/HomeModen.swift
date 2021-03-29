//
//  HomeModen.swift
//  apple (macOS)
//
//  Created by admin on 2021/3/26.
//

import Foundation
import SQLite
struct Tactic:Codable,Identifiable,Equatable {
    var id=0
    var name:String = ""
}

extension Tactic{
    static func tactics(){
        let tactic = Table("tactics")
        
        do{
            let query = try db?.prepare(tactic).map({ (row) -> Tactic in
                return try row.decode()
            }) ?? [Tactic]()
            debugPrint(query)
        }catch{
            debugPrint("error:\(error)")
        }
    }
}



