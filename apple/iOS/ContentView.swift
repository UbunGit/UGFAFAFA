//
//  ContentView.swift
//  Shared
//
//  Created by admin on 2021/3/12.
//

import SwiftUI
import CoreData


struct ContentView: View {
    
    var body: some View {
        TabView {
            SharesListView().tabItem {
                Image(systemName: "house")
                Text("首页")
            }
            SharesListView().tabItem {
                Image(systemName: "bell")
                Text("预交易")
            }
            SharesListView().tabItem {
                Image(systemName: "heart")
                Text("持仓")
            }
            
            SharesListView().tabItem {
                Image(systemName: "gearshape")
                Text("设置")
            }
            
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 8").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
