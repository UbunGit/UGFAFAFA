import Cocoa
import WebKit
import PlaygroundSupport
var greeting = "Hello, playground"


let webview = WKWebView(frame: NSRect.init(x: 0, y: 0, width: 1800, height: 600))
let url = URL(string: "http://0.0.0.0:8080")
webview.load(URLRequest.init(url: url!))

PlaygroundPage.current.setLiveView(webview)
