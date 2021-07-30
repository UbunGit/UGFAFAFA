//
//  TostView.swift
//  Demo
//
//  Created by admin on 2021/7/30.
//

import SwiftUI
import UGSwiftKit

class UGTostObser: ObservableObject {
    @Published var msg:String?
    
    init() {
     
        notif.addObserver(self, selector: #selector(alertMsg), name: NSNotification.nf_tost, object: nil)
      
    }
    @objc func alertMsg(notif:NSNotification)  {
        let moonAnimation = Animation.easeInOut.speed(30)
        withAnimation(moonAnimation) {
            msg = notif.object as? String
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(moonAnimation) {
                self.msg = nil
            }
            
        }
    }
}
struct UGTostView: View {
    @State var msg:String?
    @State var background:Color = Color.red.opacity(0.4)
    var body: some View {
        
        Text(msg ?? "")
            .padding(.top)
            .foregroundColor(.white)
            .frame(width: KWidth, height: 64, alignment: .center)
            .background(background)
            .offset(x: 0, y: -KSafeTop)
            .ignoresSafeArea(.all)
          
            
        
    }
    
    
    
}


struct TostViewDemo: View {
    @StateObject var obser = UGTostObser()
    var body: some View {
        ZStack(alignment: .top ){
            HStack{
                
                VStack{
                    Spacer()
                    Text("not").onTapGesture {
                        let edg = UIApplication.shared.delegate?.window
                        notif.post(name: NSNotification.nf_tost, object: "\(edg)--\(KWidth)")
                    }
                }
                Spacer()
            }
           
         
            if (obser.msg != nil) {
                UGTostView(msg: obser.msg)
            }
        
        }
//        .ignoresSafeArea(.all)

        .background(Color.yellow.opacity(0.1))
        
    }
}

struct TostViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        TostViewDemo()
    }
}
