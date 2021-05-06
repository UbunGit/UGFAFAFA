//
//  SwiftUIView.swift
//  
//
//  Created by admin on 2021/4/29.
//

import SwiftUI

public struct UGAnalyseView: View {
    
    @ObservedObject var store:UGAnalyse
    
    public init(store:UGAnalyse) {
        self.store = store
    }
    public var body: some View {
        HStack(spacing: 4, content: {
            
            ScrollView{
                
            }
            Form{
                Section{
                    Text("基础") 
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    baseView
                }
                Section{
                    Text("方案入参")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    ForEach(0..<store.plot.params.count, id: \.self) {
                        ParamView(item: store.plot.params[$0])
                    }
                    
                }
                
                Button(action: {
                   try? store.plotparam()
                }, label: {
                    Text("Button")
                })
                Spacer()
                
            }
            .frame(width: 300, height: .infinity , alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .datePickerStyle(DefaultDatePickerStyle())
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .background(Color.white
                            .shadow(radius: 10)
            )
        })
        
    }
    
    //
    var baseView:some View{
        
        Group{
            TextField("LocalizedStringKey", text: $store.code) { isend in
            }
            DatePicker(
                   "开始",
                   selection: $store.begin,
                   displayedComponents: [.date]
               )
 
            DatePicker(
                   "结束",
                   selection: $store.end,
                   displayedComponents: [.date]
               )
            TextField("方案", text: $store.plot.name) { isbegin in
                print(isbegin)
                if isbegin == false {
                    do{
                        try self.store.plotInfo()
                    }catch{
                        print("\(error)")
                    }
                }else{
                    print("begin")
                }
            }
            
        }
        
    }
    
    // plot view
    public var plotView:some View{
        TextField("LocalizedStringKey", text: $store.code)
    }
    
    
}

struct ParamView: View {
    @State var item:Plot.Param
    var body :some View{
        TextField(item.des, text: $item.value)
    }
}
struct UGAnalyseBodyView: View  {
    var body :some View{
        Text("body")
    }
}

struct MAResultView_Previews: PreviewProvider {
    static var previews: some View {
        
        UGAnalyseView(store: UGAnalyse())
            .background(Color.black)
    }
}
