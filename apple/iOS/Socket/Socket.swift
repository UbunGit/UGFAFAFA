//
//  Socket.swift
//  apple (iOS)
//
//  Created by admin on 2021/3/12.
//

import Foundation
import CocoaAsyncSocket

class Socketclient: NSObject,GCDAsyncSocketDelegate {
    
    let host = "10.10.11.171"
    let port = 8888
    var beatTimer:Timer?
    var state = 0 // 0初始 1链接成功
    
    var clientSocket: GCDAsyncSocket?
    
    override init() {
        super.init()
        clientSocket = GCDAsyncSocket()
        clientSocket?.delegate = self
        clientSocket?.delegateQueue = DispatchQueue.main
        print("clientSocket 初始化成功")
        connect()
    }
    
    //初始化客户端，并连接服务器
    func connect(){
    
        do {
            state = 0
            // 方法一 通过 HostName 以及端口号进行连接
            try clientSocket?.connect(toHost: host, onPort: UInt16(port))
            socketDidConnectBeginSendBeat()
    
        } catch {
            print("Failed to connect to socket.")
        }
    }
  
    
    func sendmsg(msg:String)  {
        print("发送消息\(msg)")
        let data = msg.data(using: .utf8)
        clientSocket?.write(data, withTimeout: -1, tag: 0)
        clientSocket?.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: 0)
    
    }
    func sendmsg(msg:Dictionary<String, Any>)  {
    
        guard let data:Data = try? Data(JSONSerialization.data(withJSONObject: msg,
                                                               options: JSONSerialization.WritingOptions(rawValue: 1))) else { return }
        print("发送消息\(msg)")
        clientSocket?.write(data, withTimeout: -1, tag: 0)
        clientSocket?.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: 0)
        
    }
    // 长连接建立后 开始发送心跳包
    func socketDidConnectBeginSendBeat() -> Void {
        if (beatTimer?.isValid == true) {
            beatTimer?.invalidate()
            beatTimer = nil
        }
        beatTimer = Timer.scheduledTimer(timeInterval: TimeInterval(5),
                                         target: self,
                                         selector: #selector(sendBeat),
                                         userInfo: nil,
                                         repeats: true)
        RunLoop.current.add(beatTimer!, forMode: RunLoop.Mode.common)
    }
    // 向服务器发送心跳包
    @objc func sendBeat() {
        if (state == 0) {
           
            connect()
            print("尝试重连。。。")
            return
        }

        let beat = ["c":"3"]
        sendmsg(msg: beat)
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) -> Void {
        print("连接到主机对应host:\(host) 端口\(port)")
        state = 1
        
    }

    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let str = String(data: data, encoding: .utf8)
        print(str ?? "000")
        clientSocket?.readData(withTimeout: -1, tag: 0)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("断开连接 \(err)")
        state = 0
    }
    
}




