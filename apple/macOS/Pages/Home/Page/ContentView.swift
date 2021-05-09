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
 
  
    var body: some View {
        
        Sidebar()
            .onAppear(){
            }
    }
 
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}