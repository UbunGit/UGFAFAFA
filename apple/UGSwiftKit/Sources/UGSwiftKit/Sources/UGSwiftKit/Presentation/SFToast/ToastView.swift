//
//  ToastView.swift
//  Alamofire
//
//  Created by admin on 2021/8/1.
//

import SwiftUI

let tostnotif = NotificationCenter.default

public extension NotificationCenter{
    func alert(_ msg:String) {
        tostnotif.post(name: NSNotification.nf_tost, object: msg)
    }
}

public extension NSNotification{

    static let nf_tost = Notification.Name.init("nf_tost")
}



public class UGTostObser: ObservableObject {
    
    @Published public var msg:String?
  
    public init() {
     
        tostnotif.addObserver(self, selector: #selector(alertMsg), name: NSNotification.nf_tost, object: nil)
      
    }
    @objc func alertMsg(notif:NSNotification)  {
        msg = notif.object as? String
     
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.75) {
            withAnimation(.easeOut(duration: 0.35)) {
                self.msg = nil
            }
           
            
        }
    }
}
public struct UGTostView: View {
    var msg:String?
    @State var background:Color = Color.red.opacity(0.4)
    public init(msg:String?) {
        self.msg = msg
    }
    public var body: some View {
        
        Text(msg ?? "")
            .padding(.top)
            .foregroundColor(.white)
            .frame(width: KWidth, height: 64, alignment: .center)
            .background(background)
            .offset(x: 0, y: -KSafeTop)
            .ignoresSafeArea(.all)
          
            
        
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        UGTostView(msg: nil)
    }
}
