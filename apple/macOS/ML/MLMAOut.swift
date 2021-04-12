//
//  MLMAOut.swift
//  apple
//
//  Created by admin on 2021/4/12.
//

import Foundation
import PythonKit
import CreateML


struct MLMAOut {
    
    let maModen = mlma()

    func maprediction(code:String)  {
        do{
            let data = try MakeData().getdata(code: code)
            var y1 = [Double]()
            var y2 = [Double]()
            var x = [String]()
            let temdata = data.loc()
            var i = 0
            print(data.count)
            for item in temdata {
//                if i >= data.count-1{
                if i >= 100{
                    break
                }else{
                    i = i+1
                }
                print("---0")
                print(item)
                print("---1")
                print(item["date"])
                print("---2")
                let lab = try maModen.prediction(date: Double(item["date"]) ?? 0, text: Double(item["text"]) ?? 0)
                print("---3")
                let date:Int = Int(item["date"]) ?? 0
                x.append("\(date)".toDate(dateFormat: "yyyyMMdd").toString(dateFormat: "yyyy-MM-dd"))
                print("---4")
                y1.append(lab.lable * (Double(item["close"]) ?? 0))
                print("---5")
                y2.append(Double(item["xclose"]) ?? 0)
                print("---6")
         
            }
            print("maprediction")
            let sys = Python.import("sys")
            print("Python \(sys.version_info.major).\(sys.version_info.minor)")
            let pyplot = Python.import("matplotlib.pyplot")
     
        
            pyplot.xlabel("x date")
            pyplot.ylabel("y price")
            pyplot.plot(x,y1,color:"red")
            pyplot.plot(x,y2)
            pyplot.show()
            
        }catch{
            print(error)
        }
       
    }
}







