//
//  AnalyseParamView.swift
//  UGSwiftKit
//
//  Created by admin on 2021/5/11.
//

import SwiftUI
import UGSwiftKit

class AnalyseParam: ObservableObject {
    
    @Published var analyse:Analyse = Analyse()
    @Published var share:ShareBase = ShareBase()
    
    @Published var begin:Date = Date()
    @Published var end:Date = Date()
    
    func loaddata() {
        
    }
    func indexofparam(index:Int) -> Analyse.Param {
        return (analyse.parameter[index])
    }
    
}
struct AnalyseParamView: View {
    
    @ObservedObject var store: AnalyseParam
    @State var isshowShareList = false
    @State var isshowAnalyseList = false
    
 
    
   
    public init(store:AnalyseParam){
        self.store = store
    }
    var body: some View {
        
        List{
            
            Section{
                Text("基础参数")
                    .padding()
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                baseView
            }
            Section{
                
                Text("方案参数")
                    .padding()
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
                HStack{
                    Text("\(store.analyse.name)")
                        .padding(4)
                    
                    Spacer()
                    EmptyView()
                }
                .padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("Text 2"), lineWidth: 1)
                )
                
                .background(Color.white)
                .overlay(
                    Image(systemName: "chevron.forward")
                        .padding()
                    ,
                    alignment: .trailing
                )
                .onTapGesture {
                    isshowAnalyseList.toggle()
                }
                .sheet(isPresented: $isshowAnalyseList, content: {
                    
                    SheetWithCloseView {
                        AnalyseListView(analyse: $store.analyse)
                            .padding(20)
                            .frame(minWidth: 300, idealWidth: 300, maxWidth: .infinity)
                    }
                    
                   
                    
                })
                
                ForEach(0..<store.analyse.parameter.count, id: \.self) {
                    
                    ParamView(item: $store.analyse.parameter[$0])
                }
                
            }
        }
        
    }
    
    //
    var baseView:some View{
        
        Group{
            VStack(alignment: .trailing, spacing: 2){
                
                HStack{
                    
                    Text("\(store.share.code) \(store.share.name)")
                    Spacer()
                    EmptyView()
                }
                .padding(.all,4)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("Text 2"), lineWidth: 1)
                )
                .overlay(
                        Image(systemName: "filemenu.and.selection")
                            .padding()
                            .onTapGesture {
                                isshowShareList.toggle()
                            }
                            .sheet(isPresented: $isshowShareList, content: {
                                
                                SheetWithCloseView {
                                    ShareListView(share: $store.share)
                                        .frame(minWidth: 300, idealWidth: 300, maxWidth: .infinity)
                                        .padding(20)
                                }
                              
                                
                            }),
                        alignment: .trailing
                    )
                
                Text("点击选择股票")
                    .foregroundColor(Color("Text 4"))
                    .font(.caption2)
                
                
         
            }
            
           
            DatePicker(
                "开始",
                selection: $store.begin,
                displayedComponents: [.date]
            )
            .textFieldStyle(DefaultTextFieldStyle())
            .padding(2)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("Text 2"), lineWidth: 1)
            )
            
            DatePicker(
                "结束",
                selection: $store.end,
                displayedComponents: [.date]
            )
            .padding(2)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("Text 2"), lineWidth: 1)
            )
            
 
      
        }
    }

}


struct ParamView: View {
    @Binding var item:Analyse.Param
    var body :some View{
        HStack{
            Text(item.name)
            TextField(item.name, text: $item.value)
        }
        
    }
}

struct AnalyseParamView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseParamView(store: AnalyseParam())
    }
}
