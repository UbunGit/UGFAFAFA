//
//  SwiftUIView.swift
//  
//
//  Created by admin on 2021/4/29.
//

import SwiftUI

struct UGAnalyseView: View {
    
    var body: some View {
        HStack(spacing: 4, content: {
            
            UGAnalyseBaseView()
                .background(Color.secondary.ignoresSafeArea())
            ScrollView{
                
            }
        })
        
    }
    
}

struct UGAnalyseBaseView: View {
    @State var code:String = "300022.sz" //股票代码
    @State var begin:Date = Date()
    @State var end:Date = Date()
    
    var body :some View{
        Form{
            
            TextField("LocalizedStringKey", text: $code) { isend in
                
            } onCommit: {
                
            }
            
            DatePicker(selection: $begin, label: { Text("开始时间") })
            DatePicker(selection: $begin, label: { Text("结束时间") })
            
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
