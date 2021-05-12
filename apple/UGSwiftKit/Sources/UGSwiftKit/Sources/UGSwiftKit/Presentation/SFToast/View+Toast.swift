//
//  View+Toast.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2020-02-20.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension View {

    func toast(
        context: SFToastObservable,
        style: ToastStyle = .standard
        ) -> some View  {
        print("toast:\(context.id)")
        return self
            .overlay(
                toastOverlay(isPresented: context.isActiveBinding, content: context.content ?? EmptyView().any)
            )
      
    }

    
    // MARK:Style
    func toastStyle(_ style: ToastStyle) -> some View {
        self
            .padding(style.padding)
            .background(style.background)
            .cornerRadius(style.cornerRadius)
            .foregroundColor(style.foregroundColor)
    }
    
    @ViewBuilder
    func toastOverlay<Content: View>(isPresented:Binding<Bool>, content: () -> Content,style: ToastStyle = .standard) -> some View {

        if isPresented.wrappedValue == true {
            content()
                .opacity(1)
                .toastStyle(style)
        }
    }
}

