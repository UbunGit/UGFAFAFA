//
//  View+Loading.swift
//  apple (iOS)
//
//  Created by admin on 2021/4/26.
//

import SwiftUI

public protocol SFPresentation{
    
    var loadingObser:SFLoadingObservable{get set}
    
    func showLoading(_ content:AnyView);
    
    func disLoading();
}

public extension SFPresentation{
    
    func showLoading(_ content:AnyView){
        loadingObser.present(content)
    }
    
    func disLoading(){
        loadingObser.dismiss()
    }
}


public extension View {

    func loading(
        context: SFLoadingObservable,
        style: ToastStyle = .standard
        ) -> some View  {
        print("loading 地址 :\(context.id)")
        return self
            .opacity(context.isActiveBinding.wrappedValue ? 0.2 : 1)
            .overlay(
                loadingOverlay(isPresented: context.isActive, content: context.content ?? EmptyView().any)
            )
    }

    
    // MARK:Style
    func loadingStyle(_ style: ToastStyle) -> some View {
        self
            .padding(style.padding)
            .background(style.background)
            .cornerRadius(style.cornerRadius)
            .foregroundColor(style.foregroundColor)
    }
    
    @ViewBuilder
    func loadingOverlay<Content: View>(isPresented:Bool, content: () -> Content,style: ToastStyle = .standard) -> some View {
        
        if isPresented == true {
            content()
                .opacity(1)
                .toastStyle(style)
        }
    }
}
