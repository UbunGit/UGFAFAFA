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
    

    
    
    
    func start()  {
        let queue = DispatchQueue.global(qos: .default)
        serverSocket = GCDAsyncSocket(delegate: self, delegateQueue: queue)
       
        do {
            try serverSocket?.accept( onPort: UInt16(8888))
            state = true
            print("监听成功")
        }catch _ {
            state = false
            print("监听失败")
        }
    }
    func stop()  {
        serverSocket?.disconnect()
        state = false
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectTo url: URL) {
        print("连接主机对应端口\(sock)")
        serverSocket?.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let str = String(data: data, encoding: .utf8)
        print(str ?? "000")
        serverSocket?.readData(withTimeout: -1, tag: 0)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("断开连接")
        serverSocket?.delegate = nil
    }
    

    
    
    
    
}

