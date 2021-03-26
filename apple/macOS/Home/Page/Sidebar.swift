//
//  Sidebar.swift
//  apple (macOS)
//
//  Created by admin on 2021/3/26.
//

import SwiftUI

enum NavigationItem {
    case courses
    case tutorials
    case livestreams
    case certificates
    case downloads
    case search
}
struct Sidebar: View {
    
    @State var selection: Set<NavigationItem> = [.courses]

    
    var body: some View {
        NavigationView {
        sidebar
            .frame(minWidth: 100, idealWidth: 150, maxWidth: 200, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .status) {
                    HStack {
                        Text("Meng To")
                        Spacer()
                    }
                }
                ToolbarItem(placement: .status) {
                    Image(systemName: "person.crop.circle")
                        .imageScale(.large)
                }

            }
        }
    }
    
    var sidebar:some View{
        List(selection: $selection) {
            
            NavigationLink(destination: SettingView()) {
                Label("设置", systemImage: "book.closed")
            }
            .tag(NavigationItem.courses)
            
           
        }
        .listStyle(SidebarListStyle())
    }
    
  
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
