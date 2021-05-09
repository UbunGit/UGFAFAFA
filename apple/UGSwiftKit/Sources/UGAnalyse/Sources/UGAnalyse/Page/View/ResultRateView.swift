//
//  SwiftUIView.swift
//  
//
//  Created by admin on 2021/5/8.
//

import SwiftUI
import PythonKit

struct ResultRateView: View {
    
    @State var anglyse:String
    @State var code:String
    @StateObject var webViewStore = SWWebViewStore()
    public init(anglyse:String,code:String) {
        self.anglyse = anglyse
        self.code = code
    }
    var body: some View {
        SWWebView(webView: webViewStore.webView)
            .onAppear(){
                loadweb()
            }
    }
    
    func loadweb() {
        let py_sys = Python.import("sys")
        print("Python Version: \(py_sys.version)")
        py_sys.path.append("/Users/admin/Documents/github/UGFAFAFA/code/")
        let anglyse = Python.import("Analyse.damrey")
        let df = anglyse.catchdata("000001.SZ")
        
        let kline = Python.import("chart.kline")
        let webpath = kline.kline(df).render("/Users/admin/Documents/github/UGFAFAFA/data/tem/result.html")
        let url = URL(fileURLWithPath: "\(webpath)")
        self.webViewStore.webView.loadFileURL(url, allowingReadAccessTo: url)
    }
}

struct ResultRateView_Previews: PreviewProvider {
    static var previews: some View {
        ResultRateView(anglyse: "", code: "")
    }
}
