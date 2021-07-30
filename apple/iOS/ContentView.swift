//
//  ContentView.swift
//  Shared
//
//  Created by admin on 2021/3/12.
//

import SwiftUI
import CoreData
import UGSwiftKit
import BlocksKit

class Content: ObservableObject {
    @Published var msg:String?
    init() {
     
        notif.addObserver(self, selector: #selector(alertMsg), name: NSNotification.ns_msg, object: nil)
      
    }
    @objc func alertMsg(notif:NSNotification)  {
        let moonAnimation = Animation.easeInOut.speed(3)
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

struct ContentView: View {
   
    
    @Environment(\.presentationMode) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @StateObject var obser = Content()
    
    init() {
       print("init tabbar")
    }
    var body: some View {
        ZStack(alignment:.top){
            TabView {
                AnalyseView().tabItem {
                    Image(systemName: "applescript")
                    Text("策略")
                }
               
                ShareEditView(id: 8).tabItem {
                    Image(systemName: "bell")
                    Text("预交易")
                }
                ShareDetailView(id:0).tabItem {
                    Image(systemName: "heart")
                    Text("持仓")
                }
                DataManageView().tabItem {
                    Image(systemName: "house")
                    Text("数据管理")
                }
               
            }
            if obser.msg != nil{
                Text(obser.msg ?? "")
                    .foregroundColor(.white)
                    .frame(width: KWidth, height: 64, alignment: .center)
                    .background(Color("Secondary"))
                    .padding()
            }
            
            
        }
    
        .onAppear(){
       
        }
    }
 
}
extension NSNotification{
    static let ns_msg = Notification.Name.init("msg")
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 8").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
