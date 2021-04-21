//
//  ShareEdit.swift
//  Share
//
//  Created by MBA on 2020/10/5.
//  Copyright © 2020 MBA. All rights reserved.
//

import SwiftUI
import Alamofire

struct ShareEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var store:ShareEdit
    @State var editindex:Int?
   
    
    
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
        
        VStack{
            
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5)  {
                TextFieldView(value: $store.share.name, title: "名称:")
                TextFieldView(value: $store.share.code, title: "代码:")
                TextFieldView(value: $store.share.ratioIn, title: "买入比率:")
                TextFieldView(value: $store.share.ratioOut, title: "卖出比率:")
            }
            .textFieldStyle(PlainTextFieldStyle())
            .frame(width: 300, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color("shadow"), lineWidth: 0.5)
            )
            
            groupButton
            
        }
       
        .loading(isloading: $store.loading)
        
        .alert(isPresented: $store.isalert){
            Alert(title: Text(store.alertData?.title ?? "--"),
                  message: Text(store.alertData?.msg ?? "--"),
                  dismissButton: .default(Text("OK"))
            )
        }
        .onAppear(){
            store.loadData()
        }
        
        
    }
    
    var groupButton:some View{
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            Button(action: {
                store.api_update()
            }, label: {
                Text("保存")
                    .frame(width: 150, height: 40, alignment: .center)
                    .foregroundColor(.white)
                    .font(.caption)
                    .background(Color("AccentColor"))
            })
            Button(action: {
                store.api_delete(){
                    presentationMode.wrappedValue.dismiss()
                }
            }, label: {
                Text("删除")
                    .frame(width: 150, height: 40, alignment: .center)
                    .foregroundColor(.white)
                    .font(.caption)
                    .background(Color("Primary"))
            })
            
        }
        
        .buttonStyle(BorderlessButtonStyle())
        .frame(width: 300, height: 40, alignment: .center)
        .clipShape(Capsule())
        .shadow(radius: 4)
        
    }
    
}



struct ShareEdit_Previews: PreviewProvider {
    static var previews: some View {
        ShareEditView(store: ShareEdit(id: 0))
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
