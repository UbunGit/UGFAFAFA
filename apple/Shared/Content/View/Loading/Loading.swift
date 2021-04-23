//
//  Loading.swift
//  apple (iOS)
//
//  Created by admin on 2021/4/18.
//

import SwiftUI

struct Loading: ViewModifier {
    
    var isloading:Bool
 
    public func body(content: Content) -> some View {
        
        var loadingView: some View {
            Text("loading...")
                .opacity(isloading ? 1 : 0.02)
                
        }
            
        return content
            .disabled(isloading)
            .opacity(isloading ? 0.02 : 1)
            .overlay( loadingView,
                      alignment: .center)
    }
    
}

extension View {
    // use view modifier
    public func loading(isloading:Bool) -> some View {
        
        self.modifier(Loading(isloading: isloading))
        
    }
}








