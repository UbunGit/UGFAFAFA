//
//  ArchiveSharesPage.swift
//  Share
//
//  Created by admin on 2020/12/16.
//  Copyright © 2020 MBA. All rights reserved.
//

import SwiftUI

struct ArchiveSharesPage: View {
    
    @ObservedObject var sharesStore =  ArchiveSharesPageStore()
    @State var storeid:Int?
    @State var isNavigation = false
 
    
    
    @ViewBuilder
    var body: some View {
        NavigationView{
            #if os(iOS)
            content.listStyle(InsetGroupedListStyle())
                .navigationBarItems(
                    trailing:
                        
                        HStack {
                            Text("Meng To")
                            Spacer()
                        }
                    
                )
            #else
            content.listStyle(PlainListStyle())
                .toolbar {
                
                    ToolbarItem(placement: .confirmationAction) {
                        Image(systemName: "person.crop.circle")
                            .imageScale(.large)
                    }
                    
                }
            #endif
        }
        .onAppear(perform: {
            sharesStore.update()
        })
 
        
    }
    
    var content:some View{
        List(){
            
     
            SearchView(searchText:$sharesStore.searchText)
            
            ForEach(sharesStore.shares) { item in
      
                NavigationLink(destination:  ShareDetail(shareStore: ShareDetailStore(id:item.id))){
                    ArchiveShareCell(share: item)
                        .padding(.vertical, 4)
                }
             
                
                 
                
            }
            
        }
        
        
        .navigationTitle("关注")
    }
    
}


struct ArchiveSharesPage_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveSharesPage()
    }
}
