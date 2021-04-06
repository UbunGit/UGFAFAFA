//
//  ShareDetail.swift
//  Share
//
//  Created by MBA on 2020/10/4.
//  Copyright © 2020 MBA. All rights reserved.
//

import SwiftUI

struct ShareDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var shareStore:ShareDetailStore
    
    @State var editStore:Store?
    @State var isNavStore = false
    @State var loading = false
    @State var id:Int?
    let tabs:[Segmented] = [
        Segmented(id: 0, title: "全部", icon: nil),
        Segmented(id: 1, title: "持仓", icon: nil),
        Segmented(id: 2, title: "已卖出", icon: nil)
    ]
    @State var selectTab:Segmented?
    init(shareStore:ShareDetailStore) {
        
        self.shareStore = shareStore
        
    }
    
    
    func updatePrice()  {

        shareStore.updatePrice()
    }
    @ViewBuilder
    var body: some View {
        
        #if os(iOS)
        content.listStyle(InsetGroupedListStyle())
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("\(shareStore.share.name)")
        
        
        #else
        content.listStyle(PlainListStyle())
        
        #endif
    }
    
    var content:some View{
        
        ZStack(alignment: .bottom){
            VStack {
                headview
                    .padding(.all)
                    .background(Color("AccentColor"))
                SegmentedView(tabs: tabs, selectTab: $selectTab) { (item) in
                    shareStore.reloadFitterStores(type: item!.id)
                    return
                }
                storeListView
                    .padding(.all)
                
            }
            
            
            
            VStack {
                
                HStack {
                    Spacer()
                    
                    HStack {
                        Text("添加交易")
                            .padding(.leading)
                        
                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
                            .foregroundColor(.secondary)
                            .frame(width: 44,height: 44, alignment: .center)
                    }
                    .background(Color("Background 3"))
                    .shadow(color: Color("shadow"), radius: 4, x: 4, y: 4)
                    .onTapGesture(count: 1, perform: {
                        self.editStore = Store(id: 0, share_id: 0)
                        self.isNavStore = true
                    })
                    
                    
                    
                }
                
                
                if shareStore.loading{
                    //                    LoadingView()
                    //                        .background(Color.black.opacity(0.3))
                    //                        .edgesIgnoringSafeArea(.all)
                }
            }
            
            
        }
        .onAppear(perform: {
            selectTab = tabs[0]
            shareStore.update()
            
        })
    }
    
    
    var headview:some View{
        
        //                    NavigationLink(destination: ShareEdit(shareStore: shareStore) ){
        HStack(alignment: .bottom){
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading){
                    
                    Text("持有：\(shareStore.share.getAllNum())")
                    Text("成本：¥\(shareStore.share.getAllPrice(), specifier: "%0.3f")")
                    Text(String(format:"市值：¥%0.3f", arguments: [shareStore.shizhi]))
                }
                Button(action: {updatePrice()}, label: {
                    HStack {
                        Text("现价：¥\(shareStore.price, specifier: "%0.3f")")
                        
                        Image(systemName: "goforward")
                            .font(.system(size: 12))
                            .frame(width: 16, height: 16, alignment: .center)
                    }
                    .foregroundColor(Color("Secondary"))
                })
            }
            .font(.system(size: 12))
            
            Spacer()
            VStack{
                Progress(percent:shareStore.percent, colors: [Color("Secondary"),Color("Primary")])
                    .frame(width: 80, height: 80)
                
                Text("持仓收益：¥\((shareStore.shizhi-shareStore.share.getAllPrice()), specifier: "%0.2f")")
                    .font(.system(size: 12))
                    .padding(.vertical)
                    .frame( height: 12)
            }
        }
        .foregroundColor(Color("Background 4"))
        
        
    }
    
    var storeListView:some View{
        ScrollView() {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 160), spacing: 8)],
                spacing: 8) {
                
                ForEach(shareStore.fitterStore ?? [] ){ index in

                    SroreCell(store: index, price: $shareStore.price)
                        .onTapGesture(count: 1, perform: {
                            editStore = index
                            self.isNavStore = true
                        })
                }
            }
        }
        
        
    }
    
}


struct ShareDetail_Previews: PreviewProvider {
    static var previews: some View {
        ShareDetail(shareStore: ShareDetailStore(id:0))
            .preferredColorScheme(.light)
        
    }
}



