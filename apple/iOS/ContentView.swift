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


struct ContentView: View {
   
    
    @Environment(\.presentationMode) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @StateObject var obser = UGTostObser()
    
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
                UGTostView(msg:obser.msg)
            }
            
            
        }
    
        .onAppear(){
       
        }
    }
 
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 8").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
