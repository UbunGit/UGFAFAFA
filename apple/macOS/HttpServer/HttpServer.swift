//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//    Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectSQLite


class HttpServer: NSObject,ObservableObject {
    
    @Published  var state:Bool=false
    
    func start(port:String="8181"){
        let p = Int(port) ?? 8181
        do{
            var routes = Routes()
            routes.add(method: .get, uri: "/", handler: handler)
            
            routes.add(method: .get, uri: "/api/shares/list", handler: share_list)
            routes.add(method: .get, uri: "/api/shares/detail", handler: share_detail)
            
            routes.add(method: .get, uri: "/**",
                       handler: StaticFileHandler(documentRoot: "./webroot", allowResponseFilters: true).handleRequest)
            
            
            
            try HTTPServer.launch(wait:false, name: "localhost",
                                  port: p,
                                  routes: routes,
                                  responseFilters: [
                                    (PerfectHTTPServer.HTTPFilter.contentCompression(data: [:]), HTTPFilterPriority.high)])
            
//            try HTTPServer.launch(wait:false, configurationData:configData())
            
            
            state = true
        }catch{
            print("httpserver error")
        }
        
    }
    
    
}
extension HttpServer{
    func configData() -> [String:Any] {
        return [
                "servers":[
                    [
                        "name":"localhost",
                        "port":8081,
                        "routes":[
                       
                            [
                                "methods":["get", "post"],
                                "uri":"/api/tactics",
                                "handler":"handler",
                              
                            ]
                        ]
                    ]
                ]
        ]

    }
}

extension HttpServer{
    
    public func handler(request: HTTPRequest, response: HTTPResponse) {
        // Respond with a simple message.
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "<html><title>Hello,  world!</title><body>Hello, world!</body></html>")
        // Ensure that response.completed() is called when your processing is done.
        response.completed()
    }
    

    
}

