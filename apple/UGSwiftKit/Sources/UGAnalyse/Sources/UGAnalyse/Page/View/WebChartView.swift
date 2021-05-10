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
//        self.store.webView.enclosingScrollView.bounces = false
        self.store.webView.enclosingScrollView?.verticalScrollElasticity = .allowed
        self.store.webView.enclosingScrollView?.horizontalScrollElasticity = .allowed

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


