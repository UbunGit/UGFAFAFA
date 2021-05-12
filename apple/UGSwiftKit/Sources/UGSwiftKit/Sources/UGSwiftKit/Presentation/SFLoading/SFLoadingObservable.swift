//
//  SFLoadingObservable.swift
//  apple
//
//  Created by admin on 2021/4/26.
//


import SwiftUI

public class SFLoadingObservable: SFPersentationObservable{
    

    private var task: DispatchWorkItem?
    
    public func present<Loading: View>(_ loading: @autoclosure @escaping () -> Loading) {
        presentContent(loading().any())
    }

}
