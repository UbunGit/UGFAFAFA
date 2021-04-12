//
//  SharePandans.swift
//  apple
//
//  Created by admin on 2021/4/12.
//

import Foundation
import PythonKit

struct MakeData {
    let sys = Python.import("sys")
    let os = Python.import("os")
    let pd = Python.import("pandas")

    let datapath = "./data/cvs"
    
    func getdata(code:String) throws ->PythonObject{
        do{
            sys.path.append("/Users/admin/Documents/GitHub/UGFAFAFA/code")
            let datafile = os.path.join("/Users/admin/Documents/GitHub/UGFAFAFA/data/traindata",code+".csv")
            let data = try pd.read_csv(datafile)
//            let data = try pd.read_csv(datafile,dtype:["date":"string"], index_col:0)
            return data
        }catch{
            throw error
        }
    
        
    }
}
