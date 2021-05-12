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
    
    func searchStype() -> some View {
        self.font(.title3)
            .padding(8)
            .background(Color("Text 2"))
            .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .padding(.vertical, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("Text 2"), lineWidth: 1)
            )
            .overlay(
                Image(systemName: "magnifyingglass")
                    .padding(),
                
                alignment: .trailing
            )
            
    }
    

        
}
