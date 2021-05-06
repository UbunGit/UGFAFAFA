import Cocoa
import PlaygroundSupport

import UGAnalyse


print("version:\(version)")

let analyse = UGAnalyse()
analyse.plot.name = "Maline"


import SwiftUI
let analyseView = UGAnalyseView(store:analyse)
/*:
 
 */
import PlaygroundSupport
PlaygroundPage.current.setLiveView(analyseView)
