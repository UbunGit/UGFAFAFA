//
//  SwiftUIView.swift
//  
//
//  Created by admin on 2021/4/29.
//

import SwiftUI

public struct UGAnalyseView: View {
    @State var isShowForm = true
    @ObservedObject var store:UGAnalyse
    
    public init(store:UGAnalyse) {
        self.store = store
    }
    public var body: some View {
        HStack(spacing: 4, content: {
       
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(0..<store.point.count, id: \.self) {
                        let item = store.point[$0]
                        HStack{
                            Text("\(item["date"] ?? "-" as NSObject)")
                            Text("\(item["close20v"] ?? "-" as NSObject)")
                        }
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        
                    }
                }
            }
            .padding()
            Form{
                Image(systemName:"arrow.backward.circle")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.all, 4)
                    .background(Color.black.opacity(0.1))
                    .mask(Circle())
                    .offset(x: isShowForm ? 0 : -100)
                    .onTapGesture(perform: {
                        withAnimation(){
                            isShowForm.toggle()
                        }
                        
                    })
                Section{
                    Text("基础") 
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    baseView
                }
                Section{
                    Text("方案入参")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    ForEach(0..<store.plot.params.count, id: \.self) {
                        ParamView(item: $store.plot.params[$0])
                    }
                }
                
                Button(action: {
                   try? store.plotparam()
                }, label: {
                    Text("Button")
                })
                Spacer()
                
            }
            .padding()
            .frame(width: 300, height: .infinity , alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            .datePickerStyle(DefaultDatePickerStyle())
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            .background(Color.white
                            .shadow(radius: 10)
            )
            .offset(x: isShowForm ? 0 : 300)
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
    @Binding var item:Plot.Param
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
