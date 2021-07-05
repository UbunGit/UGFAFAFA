//
//  SqliteSelectProtocol.swift
//  apple (iOS)
//
//  Created by admin on 2021/7/2.
//

import Foundation

// MARK: DELETE
public protocol SqliteSelectProtocol:SqliteProtocol{
    
    static func last() -> Self?
}

extension SqliteSelectProtocol{
    
    public static func last() -> Self?{
        return nil
    }
}
