//
//  NSImage.swift
//  apple (macOS)
//
//  Created by admin on 2021/4/25.
//

import Foundation
import AppKit

public extension NSView{
    
    func toImage(size:CGSize) -> NSImage? {
        self.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.wantsLayer = true
        let rep : NSBitmapImageRep? = self.bitmapImageRepForCachingDisplay(in: self.bounds)
        self.cacheDisplay(in: self.bounds, to: rep!)
        let data =  rep?.representation(using: NSBitmapImageRep.FileType.png, properties: [:])
        if (data != nil) {
            return NSImage.init(data: data!)
        }else{
            return nil
        }
    }
}
