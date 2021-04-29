//
//  File.swift
//  
//
//  Created by admin on 2021/4/29.
//

import Foundation
import PythonKit
struct Talib {
    /*:
     MACD
     */
    public static func macd(data:PythonObject) throws{
      
        print("MACD begin")
        let closes = data["close"]
        let py_tl = Python.import("talib")
        let rdata = py_tl.MACD(closes, fastperiod:12, slowperiod:26, signalperiod:9 )
        data["diff"] = rdata[0]
        data["dea"] = rdata[1]
        data["macd"] = rdata[2]
        print("MACD end")
   
    }
    
    /*：
     ma
     */
    public static func ma(_ data:PythonObject, times:[Int]) throws{
        print("MA begin")
        let closes = data["close"]
        let py_tl = Python.import("talib")
        for item in times {
            data["ma\(item)"] = py_tl.MA(closes,timeperiod:item)
        }
        print("MA end")
    }
    
    public static func shiftv(_ data:PythonObject, times:[Int]) throws{
        print("shiftv begin")
 
        for item in times {
           
            data["close_\(item)V"] = (data["close"].shift(-item)/data["close"]) * 10

        }
        print("shiftv end")
        
    
    }
    

}
