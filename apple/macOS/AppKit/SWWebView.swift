//
//  Bridging_VC.swift
//  apple (macOS)
//
//  Created by admin on 2021/4/15.
//

import SwiftUI
import AppKit
import WebKit


struct SWWebView : NSViewRepresentable{

    
    var url: URL
    typealias NSViewType = WKWebView
    func makeNSView(context: Context) -> WKWebView {
        let request = URLRequest(url: url)
        let webview = WKWebView()
        webview.uiDelegate = context.coordinator
        webview.navigationDelegate = context.coordinator
        webview.allowsBackForwardNavigationGestures = true;
        webview.load(request)
        return webview
    }
    
    func updateNSView(_ webview: WKWebView, context: Context) {

    }
    
    func makeCoordinator() -> Coordinator{
        return Coordinator()
    }
    

    
    class Coordinator: NSObject ,WKUIDelegate, WKNavigationDelegate{
        
        //WKNavigationDelegate
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if (navigationAction.targetFrame == nil) {
                webView.load(navigationAction.request)
            }
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }

}

