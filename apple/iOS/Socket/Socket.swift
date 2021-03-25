//
//  Socket.swift
//  apple (iOS)
//
//  Created by admin on 2021/3/12.
//

import Foundation
import CocoaAsyncSocket

class Socketclient: NSObject,GCDAsyncSocketDelegate {
    let host = "10.10.11.228"
    let port = 8081
    var timer:Timer?
    var iscontent = false
    
    var clientSocket: GCDAsyncSocket?
    
    //初始化客户端，并连接服务器
    func connect(){
        let queue = DispatchQueue.global(qos: .default)
        clientSocket = GCDAsyncSocket.init(delegate: self, delegateQueue: queue)
        do {
            // 方法一 通过 HostName 以及端口号进行连接
            iscontent =  ((try clientSocket?.connect(toHost: host, onPort: UInt16(port))) != nil)
    
        } catch {
            print("Failed to connect to socket.")
        }
    }
    
    func sendmsg(msg:String)  {
        
        let data = msg.data(using: .utf8)
        clientSocket?.write(data, withTimeout: -1, tag: 0)
    
    }
    
    func addtimer()  {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            
        })
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectTo url: URL) {
        print("连接主机对应端口\(sock)")
        clientSocket?.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let str = String(data: data, encoding: .utf8)
        print(str ?? "000")
        clientSocket?.readData(withTimeout: -1, tag: 0)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("断开连接")
        clientSocket?.delegate = nil
    }
    
}




