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
            .font(.system(size: 17, weight: .bold))
            .foregroundColor(.white)
            .padding(.all, 10)
            .background(Color.black.opacity(0.6))
            .mask(Circle())
    }
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton()
    }
}
