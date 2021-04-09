//
//  ShareEdit.swift
//  Share
//
//  Created by MBA on 2020/10/5.
//  Copyright © 2020 MBA. All rights reserved.
//

import SwiftUI
import Alamofire

struct ShareEdit: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var shareStore:ShareDetailStore
    
    @State var editindex:Int?
    @State var showSheet = false
    @State var loading = false
    
    func  updateShare()  {
        shareStore.update { (error, share) in
            loading = false
            if((error) != nil){
                let nserror = error! as NSError
                print(nserror.description as Any)
            }else{
                self.presentationMode.wrappedValue.dismiss()
                //                self.rootPresentationMode.wrappedValue.dismiss() //有问题
            }
        }
    }
    func deleteStore(index:Int) {
//        let tstore = shareStore.share.stores[index]
//        self.loading = true
//        tstore.delete(finesh: { (error)in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
//                if((error) != nil){
//                    print("error api_deleteStores")
//                    print(error?.description as Any)
//                }else{
//                    shareStore.share.stores.remove(at: index)
//                }
//                self.loading = false
//            }
//        })
        
    }
    
    func deleteShare()  {
        loading = true
        shareStore.delete { (error) in
            loading = false
            if((error) != nil){
                print(error?.description as Any)
            }else{
                self.presentationMode.wrappedValue.dismiss()
                //                self.rootPresentationMode.wrappedValue.dismiss() //有问题
            }
        }
    }
    
    func storeChenged(store:Store,index:Int?) {
//        var cstore = store
//
//        self.loading = true
//        cstore.share_id = shareStore.share.id
//        cstore.store { (error, result) in
//
//            if((error) != nil){
//                print("error api_stores")
//                print(error?.description as Any)
//            }else{
//                if index == nil {
//                    shareStore.share.stores.append(result!)
//                }else{
//                    shareStore.share.stores[index!] = result!
//                }
//                self.loading = false
//                shareStore.update { (error, share) in
//                    loading = false
//                    if((error) != nil){
//                        let nserror = error! as NSError
//                        print(nserror.description as Any)
//                    }else{
//                        self.presentationMode.wrappedValue.dismiss()
//                        //                self.rootPresentationMode.wrappedValue.dismiss() //有问题
//                    }
//                }
//            }
//        }
    }
    
    
    
    
    var body: some View {
        #if os(iOS)
        content
        #else
        content.frame(maxWidth: 800, maxHeight: 600)
        #endif
       

//        .navigationBarTitle("新增/修改")
//        .navigationBarItems(
//            trailing: HStack {
//
//
//                Button(action: deleteShare) { Image(systemName: "trash")
//                    .frame(width: 32, height: 32, alignment: .center) }
//            }
//        )
        
    }
    var content:some View{
        ZStack {
            
            if loading == false{
                ScrollView{
                    VStack{
                        
                        Section() {
                            
                            TextField("名称", text: $shareStore.share.name)
                                .frame(height: 44)
                                .padding(.leading)
                            
                            TextField("代码", text: $shareStore.share.code)
                                .padding(.leading)
                                .frame(height: 44)
                            
                            
                            TextField("买入比率", text: $shareStore.share.ratioIn)
                                .padding(.leading)
                                .frame(height: 44)
                            
                            
                            TextField("卖出比率", text: $shareStore.share.ratioOut)
                                .padding(.leading)
                                .frame(height: 44)
                            
                        }
                        
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color("shadow"), lineWidth: 0.5)
                        )
                    }
                    .padding()
                    .background(Color("Background 3"))
                    
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("shadow"), lineWidth: 0.5)
                    )
                    
       
                    
                    Button(action: {
                        self.updateShare()
                    }, label: {
                        Text("保存")
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding(.vertical,6)
                            .padding(.horizontal,12)
                            .background(Color("AccentColor"))
                            .clipShape(Capsule())
                           

                         
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    
                    
                }
 
                
            }else{
//                LoadingView()
//                    .background(Color.black.opacity(0.3))
//                    .edgesIgnoringSafeArea(.all)
            }
            
           
            
        }
    }
    
}

struct ShareEdit_Previews: PreviewProvider {
    static var previews: some View {
        ShareEdit(shareStore: ShareDetailStore(id: 0))
    }
}
