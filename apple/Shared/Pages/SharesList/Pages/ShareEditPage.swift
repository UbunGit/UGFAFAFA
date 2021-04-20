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
    
    @ObservedObject var store:ShareDetailStore
    
    @State var editindex:Int?
    @State var showSheet = false
    
    
    var body: some View {
        ZStack(alignment: .topTrailing){
            #if os(iOS)
            content
            #else
            content.frame(minWidth: 800, minHeight: 600)
            #endif
            
            CloseButton()
                .padding(20)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
        }
        
    }
    var content:some View{
        
        ScrollView{
            VStack{
                
                Section() {
                    
                    TextField("名称", text: $store.share.name)
                        .frame(height: 44)
                        .padding(.leading)
                    
                    TextField("代码", text: $store.share.code)
                        .padding(.leading)
                        .frame(height: 44)
                    
                    
                    TextField("买入比率", text: $store.share.ratioIn)
                        .padding(.leading)
                        .frame(height: 44)
                    
                    
                    TextField("卖出比率", text: $store.share.ratioOut)
                        .padding(.leading)
                        .frame(height: 44)
                    
                }
                .textFieldStyle(PlainTextFieldStyle())
                .frame(width: 300 ,alignment: .center)
                .background(Color.white)
                
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("shadow"), lineWidth: 0.5)
                )
            }
            
            .padding()
            
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("shadow"), lineWidth: 0.5)
            )
            
            
            
            Button(action: {
                store.api_update()
            }, label: {
                Text("保存")
                    .frame(minWidth: 300, maxWidth: .infinity, minHeight: 35, idealHeight: 35, maxHeight: .infinity, alignment: .center)
                    .foregroundColor(.white)
                    .font(.caption)
                    .padding(.vertical,6)
                    .padding(.horizontal,12)
                    .background(Color("AccentColor"))
                    .clipShape(Capsule())
                
                
                
            })
            .buttonStyle(BorderlessButtonStyle())
            
            
        }
        .padding(.top)
        .loading(isloading: $store.loading)
        .onAppear(){
            store.loadData()
            store.alert(error: nil)
        }
        .alert(isPresented: $store.isalert){
            Alert(title: Text(store.alertData?.title ?? "--"),
                  message: Text(store.alertData?.msg ?? "--"),
                  dismissButton: .default(Text("OK"))
            )
        }
            
            
        }
        
    }
    extension ShareEdit{
        
        func  updateShare()  {
            //        store.update { (error, share) in
            //            loading = false
            //            if((error) != nil){
            //                let nserror = error! as NSError
            //                print(nserror.description as Any)
            //            }else{
            //                self.presentationMode.wrappedValue.dismiss()
            //                //                self.rootPresentationMode.wrappedValue.dismiss() //有问题
            //            }
            //        }
        }
        func deleteStore(index:Int) {
            //        let tstore = store.share.stores[index]
            //        self.loading = true
            //        tstore.delete(finesh: { (error)in
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            //                if((error) != nil){
            //                    print("error api_deleteStores")
            //                    print(error?.description as Any)
            //                }else{
            //                    store.share.stores.remove(at: index)
            //                }
            //                self.loading = false
            //            }
            //        })
            
        }
        
        func deleteShare()  {
            //        loading = true
            //        store.delete { (error) in
            //            loading = false
            //            if((error) != nil){
            //                print(error?.description as Any)
            //            }else{
            //                self.presentationMode.wrappedValue.dismiss()
            //                //                self.rootPresentationMode.wrappedValue.dismiss() //有问题
            //            }
            //        }
        }
        
        func storeChenged(store:Store,index:Int?) {
            //        var cstore = store
            //
            //        self.loading = true
            //        cstore.share_id = store.share.id
            //        cstore.store { (error, result) in
            //
            //            if((error) != nil){
            //                print("error api_stores")
            //                print(error?.description as Any)
            //            }else{
            //                if index == nil {
            //                    store.share.stores.append(result!)
            //                }else{
            //                    store.share.stores[index!] = result!
            //                }
            //                self.loading = false
            //                store.update { (error, share) in
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
        
    }
    
    struct ShareEdit_Previews: PreviewProvider {
        static var previews: some View {
            ShareEdit(store: ShareDetailStore(id: 0))
        }
    }
