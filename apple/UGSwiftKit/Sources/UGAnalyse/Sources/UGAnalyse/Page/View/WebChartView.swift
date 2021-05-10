//
//  SwiftUIView.swift
//  
//
//  Created by admin on 2021/5/8.
//

import SwiftUI
import PythonKit

struct WebChartView: View {
   
    var store: SWWebViewStore
    public init(store:SWWebViewStore) {
        self.store = store
    }
    var body: some View {
        
        SWWebView(webView: store.webView)
            .overlay(
                Image(systemName: "arrow.counterclockwise")
                    .onTapGesture(perform: {
                        
                    }),
                alignment: .topTrailing
            )
            .padding()
        
    }
}


