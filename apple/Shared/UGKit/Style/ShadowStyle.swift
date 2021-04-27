//
//  ShadowStyle.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2020-03-05.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This struct represents a style with properties that matches
 the `SwiftUI`s `shadow` modifier.
 
 You can use the style properties together with the standard
 modifier or use the `shadow(_ style:)` `View` extension.
 
 You can specify your own standard styles by creating static,
 calculated `ShadowStyle` extension properties.
 */
public struct ShadowStyle {
    
    public init(
        color: Color = .black,
        radius: CGFloat,
        x: CGFloat,
        y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
    
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
}

public extension ShadowStyle {
    

    static var none: ShadowStyle {
        ShadowStyle(color: .clear, radius: 0, x: 0, y: 0)
    }
    // 默认
    static var defual: ShadowStyle {
        ShadowStyle(color: Color("shadow"), radius: 4, x: 2, y: 2)
    }
    // 正常
    static var normal: ShadowStyle {
        ShadowStyle(color: Color("shadow"), radius: 2, x: 2, y: 2)
    }
    

    
}


struct ShadowStyleView:View {
    
    var body: some View {
        HStack{
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                
            })
            .frame(width: 120, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            .background(Color("Background 6"))
            .cornerRadius(4)
            .shadow(ShadowStyle.normal)
        }
       
            
    }
}

struct ShadowStyleView_Previews: PreviewProvider {
    static var previews: some View {
        ShadowStyleView()
            .preferredColorScheme(.light)
    }
}


