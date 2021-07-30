//
//  ArchiveSharesPage.swift
//  Share
//
//  Created by admin on 2020/12/16.
//  Copyright © 2020 MBA. All rights reserved.
//

import SwiftUI


struct SharesListView: View {
    
    @ObservedObject var store =  SharesList()
    @State var storeid:Int?
    @State var isNavigation = false
    @State var isSheet = false

    @ViewBuilder
    var body: some View {
        
        UGPageView(loading: store.loading, alert: $store.isalert, title: store.alertData?.title, message: store.alertData?.msg){
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
        }
    }
    
    var content:some View{
   
        List(){
            
            HStack(){
                SearchView(searchText:$store.searchText)
                Button(action: {
                    isSheet = true
                }, label: {
                    Text("+")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.all, 8)
                        .background(Color("AccentColor"))
                        .mask(Circle())
                        .shadow(color: Color("shadow"), radius: 4, x: 4, y: 4)
                })
                .buttonStyle(BorderlessButtonStyle())
                .sheet(isPresented: $isSheet){
                    ShareEditView(id: 0)
                }
            }
            
            if store.shares != nil{
                ForEach(store.shares!) { item in

                    NavigationLink(destination:  ShareDetailView(id:item.id)){
                        ShareCell(share: item)
                            .padding(.vertical, 4)
                    }

                }
            }
           
            
        }
        .onAppear(){
            store.update()
        }
    }
    
}

public struct UGPageView<Content> : View where Content : View {
    
    let content: Content
    var loading:Bool
    var alert:Binding<Bool>
    var message:String?
    var title:String?
    
    
    init(loading:Bool, alert:Binding<Bool>, title:String?, message:String?, @ViewBuilder content: () -> Content) {
        self.alert = alert
        self.loading = loading
        self.message = message
        self.title = title
        self.content = content()
    }
    
    public var body: some View {
        content
//            .loading(isloading: loading){
//                Text("loading...")
//            }
            .alert(isPresented: alert){
                Alert(title: Text(title ?? "--"),
                      message: Text(message ?? "--"),
                      dismissButton: .default(Text("OK"))
                )
            }
        
    }
}


struct ArchiveSharesPage_Previews: PreviewProvider {
    static var previews: some View {
        SharesListView()
    }
}
