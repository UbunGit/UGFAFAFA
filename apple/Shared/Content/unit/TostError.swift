//
//  AlertError.swift
//  Share
//
//  Created by admin on 2020/12/25.
//  Copyright © 2020 MBA. All rights reserved.
//

import Foundation

struct TostError: Error,Identifiable {
    var id = 0
    
    enum TostLevel {
        case debug
        case info
        case warm
        case error
    }

    let code: Int
    let msg: String
    let title: String
    let level: TostLevel
}
