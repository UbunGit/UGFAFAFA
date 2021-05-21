//
//  SocketManage.swift
//  apple (iOS)
//
//  Created by admin on 2021/5/21.
//

/**:
 开源文档
 https://github.com/socketio/socket.io-client-swift
 */
import Foundation
import SocketIO

let config : [String: Any] = ["log": true,
                              "compress": true,
                              "forcePolling": true,
                              "forceNew": true]
let manager = SocketManager(socketURL: URL(string: "http://localhost:5000")!, config: [.log(true), .compress])

let scokeClient = manager.defaultSocket

func processSocket(){

//
//    scokeClient.on("currentAmount") {data, ack in
//       print("currentAmount")
//    }
    scokeClient.on("error") { data, ack in
        print("scokeClient error")
    }
    scokeClient.on("my response") { data, ack in
        print("server_response")
    }

    
    scokeClient.connect(timeoutAfter: 5) {
        print("connect error")
    }
    
   
}
extension JSONDecoder{
    
    open func decode<T>(_ type: T.Type, from any: Any) throws -> T where T : Decodable{
        let jsonData = try JSONSerialization.data(withJSONObject: any, options: [])
        return try JSONDecoder().decode(type, from: jsonData)
    }
}


struct ScokeResult: Codable {

    var code:Int?
    var msg:String?
//    var data:Codable
    
}







