//
//  File.swift
//  apple
//
//  Created by admin on 2021/4/26.
//

import SwiftUI

extension View {

    public func shadow(_ style: ShadowStyle) -> some View {
        shadow(
            color: style.color,
            radius: style.radius,
            x: style.x,
            y: style.y)
    }
    
    public func searchStype() -> some View {
        self.font(.title3)
            .padding(4)
            .background(Color("Background 1"))
            .mask(RoundedRectangle(cornerRadius: 4, style: .continuous))
            .padding(.vertical, 4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("Text 2"), lineWidth: 1)
            )
            .overlay(
                Image(systemName: "magnifyingglass")
                    .padding(),
                
                alignment: .trailing
            )
            
    }
      
}
