//
//  ShareDetail.swift
//  Share
//
//  Created by MBA on 2020/10/4.
//  Copyright © 2020 MBA. All rights reserved.
//

import SwiftUI

struct ShareDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    
    @ObservedObject var store:ShareDetail
    @State var context = SFToastObservable()
    @State var isSheet = false
    @State var sheetCount = 0
    
    
    init(id:Int) {
        store = ShareDetail(id: id)
    }
    
    let tabs:[Segmented] = [
        Segmented(id: 0, title: "全部", icon: nil),
        Segmented(id: 1, title: "持仓", icon: nil),
        Segmented(id: 2, title: "已卖出", icon: nil)
    ]
    @State var selectTab:Segmented?
    
    
    
    @ViewBuilder
    var body: some View {
        
        UGPageView(loading: store.loading, alert: $store.isalert, title: store.alertData?.title, message: store.alertData?.msg){
            #if os(iOS)
            content.listStyle(InsetGroupedListStyle())
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("\(store.share.name)")
            
            
            #else
            content.listStyle(PlainListStyle())
            
            #endif
        }
        
        
        .sheet(isPresented: self.$isSheet,onDismiss: {
            print("999999")
        }){
            
            ShareEditView(id: store.id)
        }
        
        
        
    }
    
    var content:some View{
        
        return ZStack(alignment: .bottom){
            VStack {
                headview
                    .padding(.all)
                    .background(Color("AccentColor"))
                    .onTapGesture(count: 1, perform: {
                        
                        self.isSheet = true
                    })
                SegmentedView(tabs: tabs, selectTab: $selectTab) { (item) in
                    store.reloadFitterStores(type: item!.id)
                    return
                }
                storeListView
                    .padding(.all)
                
            }
            
            addStoreView
            
            
            
        }
        .font(.caption)
        .foregroundColor(Color("Background 4"))
        
        .onAppear(perform: {
            selectTab = tabs[0]
            store.loadData()
        })
    }
    
    
    var headview:some View{
        
        HStack(alignment: .bottom){
            
            VStack(alignment: .leading){
                
                Text("累计收益：¥\((store.profited), specifier: "%0.2f")")
            }
            Spacer()
            VStack{
                Progress(percent:store.percent, colors: [Color("Secondary"),Color("Primary")])
                    .frame(width: 60, height: 60)
                
                VStack(alignment: .leading) {
                    
                    VStack(alignment: .leading){
                        
                        Text("持仓数量：\(store.share.getAllNum(state: 0))")
                        Text("持仓成本：¥\(store.share.getAllPrice(state: 0), specifier: "%0.3f")")
                        Text("持仓市值：¥\(store.shizhi, specifier: "%0.3f")")
                        Text("持仓收益：¥\((store.profit), specifier: "%0.2f")")
                    }
                    Button(action: { store.updatePrice()}, label: {
                        HStack {
                            Text("现价：¥\(store.price, specifier: "%0.3f")")
                                .foregroundColor(Color("Secondary"))
                            Image(systemName: "goforward")
                                .frame(width: 16, height: 16, alignment: .center)
                        }
                        
                    })
                }
                
                
            }
        }
        
        
        
    }
    
    var storeListView:some View{
        ScrollView() {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 160), spacing: 8)],
                spacing: 8) {
                
                ForEach(store.fitterStore ?? [] ){ index in
                    
                    SroreCell(store: index, price: $store.price)
                        .onTapGesture(count: 1, perform: {
                            
                        })
                }
            }
        }
    }
    
    var addStoreView:some View{
        HStack {
            Spacer()
            
            HStack {
                Text("添加交易")
                    .padding(.leading)
                
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    .frame(width: 44,height: 44, alignment: .center)
            }
            .foregroundColor(.secondary)
            .background(Color("Background 3"))
            .onTapGesture(count: 1, perform: {
                
            })
        }
        .shadow(color: Color("shadow"), radius: 4, x: 4, y: 4)
    }
    
}


struct ShareDetail_Previews: PreviewProvider {
    static var previews: some View {
        ShareDetailView(id:0)
            .preferredColorScheme(.light)
        
    }
}



