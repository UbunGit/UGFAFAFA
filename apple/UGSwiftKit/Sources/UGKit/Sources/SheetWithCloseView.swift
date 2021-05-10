//
//  File.swift
//  Alamofire-iOS
//
//  Created by admin on 2021/4/25.
//

import Foundation
import SwiftUI


struct  SheetWithCloseView <Content: View>: View{
    @Environment(\.presentationMode) var presentationMode
    let content:Content
    
    init(@ViewBuilder content: () -> Content) {
           self.content = content()
    }
    var body:some View{
        content.overlay(
            CloseButton().onTapGesture {
                presentationMode.wrappedValue.dismiss()
            },
            alignment: .topLeading
                
        )
    }
}

