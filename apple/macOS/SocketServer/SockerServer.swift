//
//  SockerServer.swift
//  apple (iOS)
//
//  Created by admin on 2021/3/12.
//

import Foundation
import CocoaAsyncSocket

class ClientSocket: GCDAsyncSocket {
    
 
}
class TcpSocketServer: NSObject,GCDAsyncSocketDelegate {
    
    var state:Bool=false
    //服务端和客户端的socket引用
    var serverSocket: GCDAsyncSocket?
    var clientSockets = NSMutableArray()
    
    override init() {
        super.init()
    }

    func start(port:String)  {
        print("start")
        let p = UInt16(port) ?? 8888
        let queue = DispatchQueue.main
        serverSocket = GCDAsyncSocket(delegate: self, delegateQueue: queue)
        do {
            try serverSocket?.accept( onPort: p)
            state = true
            print("监听\(p)成功")
        }catch _ {
            state = false
            print("监听失败")
        }
    }
    func stop()  {
//        serverSocket?.disconnect()
//        serverSocket?.delegate = nil
//        serverSocket = nil
//        state = false
//        print("stop")
    }
    
    func sendmsg(client:GCDAsyncSocket, msg:Dictionary<String, Any>)  {
        guard let data:Data = try? Data(JSONSerialization.data(withJSONObject: msg,
                                                               options: JSONSerialization.WritingOptions(rawValue: 1))) else { return }
        print("发送消息\(msg)")
        client.write(data, withTimeout: -1, tag: 0)
        client.readData(withTimeout: -1, tag: 0)
        
    }
    
  
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
       
        if (clientSockets.contains(newSocket)) {
            print("client 已经存在！")
            return
        }
        clientSockets.add(newSocket)
        let beat = ["a":"0"]
        sendmsg(client: newSocket, msg: beat)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:AnyObject]
        print(json ?? "Empty Data")
        sock.readData(withTimeout: -1, tag: 0)
    }
}

