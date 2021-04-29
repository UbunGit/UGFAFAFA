//
//  File.swift
//  
//
//  Created by admin on 2021/4/29.
//

import Foundation

public struct LineLib<T:Comparable> {
    
    public struct Line{
        var begin:T
        var end:T
    }
    
    public enum lineStatus {
        case none
        case upparallel // 上不相交
        case downparallel // 下不相交
        case upintersect // 向上相交
        case downintersect // 向下相交
    }
    public static func states(line1:Line, line2:Line) -> lineStatus{
        if (line1.begin > line2.begin) && (line1.end > line2.end) {
            return .upparallel
        }
        if (line1.begin < line2.begin) && (line1.end < line2.end) {
            return .downparallel
        }
        if (line1.begin >= line2.begin) && (line1.end < line2.end) {
            return .downintersect
        }
        if (line1.begin <= line2.begin) && (line1.end > line2.end) {
            return .upintersect
        }
        return .none
    }
}
