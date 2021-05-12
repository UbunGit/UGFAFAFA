//
//  ToastStyle.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2020-03-18.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This style can be used when presenting a toast over a view,
 to apply a custom style to the toast.
 */
public struct ToastStyle {

    
    public let background: AnyView
    public let foregroundColor:Color
    public let padding: CGFloat
    public let cornerRadius: CGFloat
    public let shadowStyle: ShadowStyle
   
}

public extension ToastStyle {
    

    static var defual: ToastStyle {
        ToastStyle(background: Color.clear.any(), foregroundColor: .white, padding: 8, cornerRadius: 4, shadowStyle: .none)
    }

    static var standard: ToastStyle {
        ToastStyle(background: Color("Background 6").opacity(4).any(), foregroundColor: .white, padding: 8, cornerRadius: 4, shadowStyle: .defual)
    }
}
