//
//  SFLoadingObservable.swift
//  apple
//
//  Created by admin on 2021/4/26.
//


import SwiftUI

public class SFLoadingObservable: SFPersentationObservable{
    
    public var duration:TimeInterval = 3
    private var task: DispatchWorkItem?
    
    public func present<Loading: View>(_ loading: @autoclosure @escaping () -> Loading) {
        presentContent(loading().any())
    }

}
