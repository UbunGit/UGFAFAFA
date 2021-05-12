//
//  ShareEdit.swift
//  Share
//
//  Created by MBA on 2020/10/5.
//  Copyright © 2020 MBA. All rights reserved.
//

import SwiftUI
import Alamofire
import UGSwiftKit

struct ShareEditView: View,SFPresentation {
   
    
  
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var store:ShareEdit
    @State var context = SFToastObservable()
    @ObservedObject var loadingObser = SFLoadingObservable()
    
    init(id:Int) {
        
        self.store = ShareEdit()
        self.store.id = id
    }
    
    var body: some View {
  
            ZStack(){
                
                #if os(iOS)
                content
                    .navigationTitle("section.title")
                    .navigationBarTitleDisplayMode(.inline)
                #else
                content.frame(minWidth: 600, minHeight: 600)
                #endif
                
                HStack(){
                    Spacer()
                    VStack(alignment: .trailing){
                        
                        CloseButton()
                            .padding(20)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                        Spacer()
                    }
                }
                
            }
      
        .onAppear(){
            showLoading( VStack{Text("loading...")}.any() )
            store.loadData { (error) in
                disLoading()
                if((error) != nil){
                    context.present(Text(error!.msg).any())
                }
            }

        }
        .toast(context: context)
        .loading(context: loadingObser)
        
    }
    
    var content:some View{
        
        VStack{
            
            Text((store.id == 0) ? "新增" : "修改")
                .font(.title)
                
                .padding(.leading)
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5)  {
                TextFieldView(value: $store.share.name, title: "名称:")
                TextFieldView(value: $store.share.code, title: "代码:")
                TextFieldView(value: $store.share.ratioIn, title: "买入比率:")
                TextFieldView(value: $store.share.ratioOut, title: "卖出比率:")
            }
            .textFieldStyle(PlainTextFieldStyle())
            .frame(minWidth: 300, idealWidth: 300, maxWidth: 300,  alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color("shadow"), lineWidth: 0.1)
            )
            
            groupButton
                .padding()
            
        }
 
    }
    
    var groupButton:some View{
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            Button(action: {
                store.api_update()
            }, label: {
                Text("保存")
                    .frame(width: 150, height: 40, alignment: .center)
                    .foregroundColor(Color("Text 1"))
                    .font(.caption)
                    .background(Color("Commit"))
            })
            if store.id != 0{
                Button(action: {
                    store.api_delete(){
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("删除")
                        .frame(width: 150, height: 40, alignment: .center)
                        .foregroundColor(Color("Text 1"))
                        .font(.caption)
                        .background(Color("Cancle"))
                })
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .frame(width: 300, height: 40, alignment: .center)
        .clipShape(Capsule())
        .shadow(radius: 4)
    }
    
}



struct ShareEdit_Previews: PreviewProvider {
    static var previews: some View {
        ShareEditView(id: 0)
    }
}

struct TextFieldView: View {
    @Binding var value:String
    @State var title:String
    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 8){
            Text(title)
                .padding(.leading)
            
            
            
            TextField(title, text: $value)
                .frame(height: 44)
        }
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color("shadow"), lineWidth: 0.5)
        )
    }
}
