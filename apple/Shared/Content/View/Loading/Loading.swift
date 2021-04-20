//
//  Loading.swift
//  apple (iOS)
//
//  Created by admin on 2021/4/18.
//

import SwiftUI

struct Loading: ViewModifier {
    
    @Binding var isloading:Bool
 
    public func body(content: Content) -> some View {
        
        var loadingView: some View {
            Text("loading...")
                .opacity(isloading ? 1 : 0.02)
        }
            
        return content
            .opacity(isloading ? 0.02 : 1)
            .overlay( loadingView,
                      alignment: .center)
           
            .onAppear(){
              
            }
    }
    
}

extension View {
    // use view modifier
    public func loading(isloading:Binding<Bool>) -> some View {
        withAnimation (.linear(duration: 3)){
            self.modifier(Loading(isloading: isloading))
        }
        
        
    }
}




