//
//  File.swift
//  apple
//
//  Created by admin on 2021/4/26.
//

import SwiftUI
public extension View {

    func shadow(_ style: ShadowStyle) -> some View {
        shadow(
            color: style.color,
            radius: style.radius,
            x: style.x,
            y: style.y)
    }
}
