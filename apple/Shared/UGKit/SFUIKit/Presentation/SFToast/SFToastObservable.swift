//
//  SFToastObservable.swift
//  apple
//
//  Created by admin on 2021/4/24.
//


import SwiftUI

class SFToastObservable: PersenttationObservable<AnyView> {
    
   
}


struct SFToast: ViewModifier {
    
    var observable:SFToastObservable
 
    public func body(content: Content) -> some View {
        
        if observable.isActive {
         
            return content

        }else{
            return content
        }
    }
}

extension View {
    // use view modifier
//    public func sfToast(observable:SFToastObservable<Any>) -> some View {
//
//        self.modifier(SFToast(observable: observable))
//
//    }
}


