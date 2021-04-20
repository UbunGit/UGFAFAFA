//
//  SwiftUIView.swift
//  apple (macOS)
//
//  Created by admin on 2021/4/15.
//

import SwiftUI

struct WebPage: View {
    var body: some View {
        SWWebView(url: URL.init(string: "https://www.baidu.com")!)
            .padding(.all)
        
    }
}

struct WebPage_Previews: PreviewProvider {
    static var previews: some View {
        WebPage()
    }
}
