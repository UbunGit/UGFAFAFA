//
//  ArchiveSharesPage.swift
//  Share
//
//  Created by admin on 2020/12/16.
//  Copyright © 2020 MBA. All rights reserved.
//

import SwiftUI

struct SharesListView: View {
    
    @ObservedObject var sharesStore =  SharesList()
    @State var storeid:Int?
    @State var isNavigation = false
    @State var isSheet = false
 
    
    
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
        .sheet(isPresented: $isSheet){
            ShareEditView(store: ShareEdit(id: 0))
        }
        .onAppear(perform: {
            sharesStore.update()
        })
 
        
    }
    
    var content:some View{
        List(){
            
            HStack{
                SearchView(searchText:$sharesStore.searchText)
                Button(action: {
                    isSheet = true
                }, label: {
                    Text("+")
                        .foregroundColor( Color("AccentColor"))
                        .font(.caption)
                        .padding(.vertical,4)
                        .padding(.horizontal,4)
                        .clipShape(Capsule())
                })
                .buttonStyle(BorderlessButtonStyle())
            }
            
            
            ForEach(sharesStore.shares) { item in
      
                NavigationLink(destination:  ShareDetailView(shareStore: ShareDetail(id:item.id))){
                    ShareCell(share: item)
                        .padding(.vertical, 4)
                } 
                
            }
            
        }
        
        
        .navigationTitle("关注")
    }
    
}


struct ArchiveSharesPage_Previews: PreviewProvider {
    static var previews: some View {
        SharesListView()
    }
}
