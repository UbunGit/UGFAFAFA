//
//  File.swift
//  Alamofire-iOS
//
//  Created by admin on 2021/4/25.
//

import Foundation
import SwiftUI


public struct SheetWithCloseView <Content: View>: View{
    
    @Environment(\.presentationMode) var presentationMode
    let content:Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    public var body:some View{
        ZStack(alignment: .topTrailing){
            content
           
            CloseButton()
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
        }.frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 300, idealHeight: 300, maxHeight: 300, alignment: .center)
        
    }
}
struct SheetWithCloseView_Previews: PreviewProvider {
 
    static var previews: some View {
        SheetWithCloseView {
            Text("hello")
        }
    
    }
}


