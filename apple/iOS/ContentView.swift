//
//  ContentView.swift
//  Shared
//
//  Created by admin on 2021/3/12.
//

import SwiftUI
import CoreData


struct ContentView: View {
   
    @Environment(\.presentationMode) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    
    init() {
       print("init tabbar")
    }
    var body: some View {
        TabView {
            SharesListView().tabItem {
                Image(systemName: "house")
                Text("首页")
            }
            ShareEditView(id: 8).tabItem {
                Image(systemName: "bell")
                Text("预交易")
            }
            ShareDetailView(id:0).tabItem {
                Image(systemName: "heart")
                Text("持仓")
            }
            AnalyseView().tabItem {
                Image(systemName: "applescript")
                Text("策略")
            }
        }
        .onAppear(){
//            processSocket()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 8").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
