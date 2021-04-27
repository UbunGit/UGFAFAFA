//
//  SFToastObservable.swift
//  apple
//
//  Created by admin on 2021/4/24.
//


import SwiftUI

public class SFToastObservable: SFPersentationObservable {
    
    public var duration:TimeInterval = 3
    private var task: DispatchWorkItem?
    
    public func present<Toast: View>(_ toast: @autoclosure @escaping () -> Toast) {
        
        if content != nil {
            self.dismiss()
        }
        presentContent(toast().any())
        task?.cancel()
        task = DispatchWorkItem {
            self.dismiss()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: task!)
    }

}




