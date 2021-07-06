//
//  appleApp.swift
//  Shared
//
//  Created by admin on 2021/3/12.
//

import SwiftUI
import DoraemonKit

@main
struct appleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .font(.callout)
                .foregroundColor(Color("Text 5"))
                .onAppear(){
                    DoraemonManager.shareInstance().install(withPid: "db4146378948b4a04e74c1172ce45590")
                  
                }
            
        }
    }
}
