//
//  SwiftUIView.swift
//  apple (macOS)
//
//  Created by admin on 2021/4/15.
//

import SwiftUI

struct WebPage: View {
    @StateObject var webViewStore = SWWebViewStore()
    
    var body: some View {
        VStack{
            SWWebView(webView: webViewStore.webView)
                .padding(.all)
            toolView
        }
        .onAppear(){
            let url = URL(fileURLWithPath: "/Users/admin/Documents/GitHub/UGFAFAFA/data/tem/result.html")
            self.webViewStore.webView.loadFileURL(url, allowingReadAccessTo: url)
        }
        
        
    }
    
    var toolView: some View {
        
        HStack{
            Button(action: {
                webViewStore.webView.reload()
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
