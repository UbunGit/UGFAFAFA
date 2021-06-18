//
//  SFPersentationObservable.swift
//  apple
//
//  Created by admin on 2021/4/24.
//

import Foundation
import SwiftUI

enum SFPresentationType {
    case toast
    case alert
    case sheet
}

public class SFPersentationObservable: ObservableObject {

   
    var id:UUID
    @Published public var isActive = false
    
    public var isActiveBinding: Binding<Bool> {
        .init(
            get: {
                print("get isActiveBinding 地址 : \(self.id))")
                return  self.isActive
                
            },
            set: {
                print("set isActiveBinding 地址 : \(self.id)")
                self.isActive = $0
                
            }
        )
    }
    
    @Published public internal(set) var content: (() -> AnyView)? {
        didSet { isActive = (content != nil) }
    }
    
    public init() {
        id = UUID()
    }
    
    public func dismiss() {
        print("dismiss地址 :\(self.id)")
        withAnimation(.spring()) {
            content = nil
            isActive = false
        }
    }
    
    public func presentContent(_ content: @autoclosure @escaping () -> AnyView) {
        print("presentContent地址 :\(self.id)")
        self.content = content
    }
}

public extension View {
   
    func any() -> AnyView {
        AnyView(self)
    }
}

