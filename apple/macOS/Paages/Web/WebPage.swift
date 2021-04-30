//
//  SwiftUIView.swift
//  apple (macOS)
//
//  Created by admin on 2021/4/15.
//

import SwiftUI

struct WebPage: View {
    
    var body: some View {
        VStack{
            SWWebView(url: URL.init(string: "https://www.baidu.com")!)
                .padding(.all)
            toolView
        }
        
        
    }
    
    var toolView: some View {
        
        HStack{
            Button(action: {
               
            }, label: {
                Text("刷新")
                    .frame(width: 150, height: 40, alignment: .center)
                    .foregroundColor(Color("Text 1"))
                    .font(.caption)
                    .background(Color("Cancle"))
            })
        }
        
    }
}

struct WebPage_Previews: PreviewProvider {
    static var previews: some View {
        WebPage()
    }
}
