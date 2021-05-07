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
 */
import PlaygroundSupport
PlaygroundPage.current.setLiveView(analyseView)
