//
//  appleApp.swift
//  Shared
//
//  Created by admin on 2021/3/12.
//

import SwiftUI

@main
struct appleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
