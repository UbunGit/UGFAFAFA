//
//  Persenttation.swift
//  apple
//
//  Created by admin on 2021/4/24.
//

import Foundation

public class PersenttationObservable<Content>: ObservableObject {
    
    @Published public var isActive = false
    
    @Published public internal(set) var content: (() -> Content)? {
        didSet { isActive = (content != nil) }
    }
}

