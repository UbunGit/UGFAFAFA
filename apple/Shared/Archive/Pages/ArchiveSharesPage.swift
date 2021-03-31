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
    
    var body: some View {
        
        NavigationView{
            ZStack {
//                NavigationLink(destination: ShareDetail(shareStore: ShareDetailStore(id: storeid)), isActive: $isNavigation ) {
//                    EmptyView()
//                }
             
                List{
                  
                        ForEach(sharesStore.shares) { item in
                            
                            ArchiveShareCell(share: item)
                                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                    storeid = item.id
                                    self.isNavigation = true
                                })
                            
                        }
               
                }
                if sharesStore.loading == true{
//                    LoadingView()
//                        .background(Color.black.opacity(0.3))
//                        .edgesIgnoringSafeArea(.all)
                }
            }
            .onAppear(perform: {
                sharesStore.update()
            })
            .navigationBarTitle(Text("收藏"))
//            .navigationBarItems(
//                trailing: NavigationLink(destination: ShareEdit(shareStore: ShareDetailStore(id: nil))) {
//                    Image(systemName: "plus.circle")
//                        .frame(width: 32, height: 32, alignment: .center)
//                }.buttonStyle(PlainButtonStyle())
//                
//            )
        }
    }
}


struct ArchiveSharesPage_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveSharesPage()
    }
}
