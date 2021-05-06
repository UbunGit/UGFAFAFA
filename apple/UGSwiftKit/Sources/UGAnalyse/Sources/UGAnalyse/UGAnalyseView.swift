//
//  SwiftUIView.swift
//  
//
//  Created by admin on 2021/4/29.
//

import SwiftUI

struct UGAnalyseView: View {
    @ObservedObject var store = UGAnalyse()
    
    var body: some View {
        HStack(spacing: 4, content: {

            ScrollView{
                
            }
            UGAnalyseBaseView(code: $store.code, begin: $store.begin, end: $store.end)
                .frame(width: 200)
                .background(Color.secondary.ignoresSafeArea())
        })
        
    }
    
}

struct UGAnalyseBaseView: View {
    @Binding var code:String
    @Binding var begin:Date
    @Binding var end:Date
    
    var body :some View{
        Form{
            Section{
                TextField("LocalizedStringKey", text: $code) { isend in
                    
                } onCommit: {
                    
                }
                
                DatePicker(selection: $begin, label: { Text("开始") })
                    
                 
                DatePicker(selection: $begin, label: { Text("结束") })
            }
            
            
            Button(action: {}, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            })
            .background(Color.yellow)
            Spacer()
        }
        .padding()
        
    }
    
}

struct UGAnalyseBodyView: View  {
    var body :some View{
        Text("body")
    }
}

struct MAResultView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UGAnalyseView()
                
                .frame(width: 600, height: 400, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
        }
    }
}
