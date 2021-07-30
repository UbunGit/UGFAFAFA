//
//  UGScreen.swift
//  Pods
//
//  Created by admin on 2021/7/2.
//

import Foundation
/// 屏幕宽度
public let KWidth = UIScreen.main.bounds.width
/// 屏幕高度
public let KHeight = UIScreen.main.bounds.height

/// 安全上部距离
public let KSafeTop:CGFloat = UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0

/// 安全底部距离
public let KSafeBottom:CGFloat = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
