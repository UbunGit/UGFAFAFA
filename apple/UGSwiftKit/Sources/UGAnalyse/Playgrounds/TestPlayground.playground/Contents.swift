import Cocoa
import PlaygroundSupport

import UGAnalyse


print("version:\(version)")

let analyse = UGAnalyse()
analyse.plot.name = "maline"


import SwiftUI
let analyseView = UGAnalyseView(store:analyse)
/*:
 ## 展示内容
 
 ```flow
 s=start:开始
 e=end:结束
 o=operation:操作项

 s-o-e
 ```
 */
import PlaygroundSupport
PlaygroundPage.current.setLiveView(analyseView)
