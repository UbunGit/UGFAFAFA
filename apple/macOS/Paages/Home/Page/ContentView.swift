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
 
    @ObservedObject var socketServer = TcpSocketServer()
    @ObservedObject var httpServer = HttpServer()

    var body: some View {
        
        Sidebar()
            .onAppear(){
                socketServer.start()
                httpServer.start()
            }

    }
    
  
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
