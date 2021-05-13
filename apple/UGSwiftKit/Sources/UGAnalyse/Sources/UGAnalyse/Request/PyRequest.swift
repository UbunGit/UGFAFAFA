//
//  File.swift
//  
//
//  Created by admin on 2021/5/13.
//

import Foundation
import PythonKit


public protocol PyRequest {
    
}

public extension PyRequest{
    
    /*:
     # 获取回测数据
     */
    func backtrading(analyse:String,
                     code:String,
                     begin:String?,
                     end:String?,
                     finesh:@escaping  (Result<PythonObject, BaseError>) ->  ()){
        
            do{
                let py_sys = try Python.attemptImport("sys")
                py_sys.path.append("/Users/admin/Documents/github/UGFAFAFA/code")
                let name = "Analyse.\(analyse)"
                let py_anglyse = try  Python.attemptImport(name)
                let traddata = py_anglyse.backtrading(code:code,
                                                        begin:begin,
                                                        end:end)
                finesh(.success(traddata))
            }catch{
                finesh(.failure(BaseError(code: -1, msg: "\(error)")))
            }

    }
}

