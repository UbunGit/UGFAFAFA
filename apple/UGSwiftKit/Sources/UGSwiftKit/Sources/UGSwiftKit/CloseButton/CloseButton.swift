//
//  CloseButton.swift
//  apple
//
//  Created by admin on 2021/4/19.
//

import SwiftUI

public struct CloseButton: View {
    public init() {
        
    }
    public var body: some View {
        Image(systemName: "xmark")
            .padding(10)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.white)
            .background(Color.black.opacity(0.3))
            .mask(Circle())
            .padding(10)
            
    }
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton()
    }
}
