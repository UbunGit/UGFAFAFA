//
//  UGCoderApp.swift
//  Shared
//
//  Created by admin on 2021/4/25.
//

import SwiftUI

@main
struct UGCoderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
