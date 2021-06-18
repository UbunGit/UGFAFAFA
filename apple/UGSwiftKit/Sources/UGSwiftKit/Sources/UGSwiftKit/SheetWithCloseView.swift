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
        GeometryReader(content: { geometry in
            VStack(alignment: .center){
                HStack{
                    Spacer()
                    CloseButton()
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                }
               
                content

            }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .trailing)
        })
  
        
    }
}
struct SheetWithCloseView_Previews: PreviewProvider {
 
    static var previews: some View {
        SheetWithCloseView {
            Text("hello")
        }
    
    }
}


