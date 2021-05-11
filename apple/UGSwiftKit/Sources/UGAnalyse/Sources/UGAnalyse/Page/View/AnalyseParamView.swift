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
        return (analyse.params[index])
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
        
        Form{
            
            Section{
                Text("基础")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                baseView
            }
            Section{
                
                Text("方案入参")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
                ForEach(0..<store.analyse.params.count, id: \.self) {
                    
                    ParamView(item: $store.analyse.params[$0])
                }
                
            }
        }
        
    }
    
    //
    var baseView:some View{
        
        Group{
            HStack{
                Text("\(store.share.code)")
                Spacer()
                EmptyView()
            }.padding()
                .overlay(
                    Image(systemName: "filemenu.and.selection")
                        .onTapGesture {
                            isshowShareList.toggle()
                        }
                        .sheet(isPresented: $isshowShareList, content: {
                            
                            SheetWithCloseView {
                                ShareListView(share: $store.share)
                            }
                            .frame(minWidth: 300, idealWidth: 300, maxWidth: .infinity)
                            .padding(EdgeInsets.init(top: 10, leading: 20, bottom: 30, trailing: 40))
                            
                        }),
                    alignment: .trailing
                )
            
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
            
 
            HStack{
                Text("\(store.analyse.name)")
                
                Spacer()
                EmptyView()
            }
            .padding(4)
            .background(Color.white)
            .overlay(
                Image(systemName: "chevron.forward")
                ,
                alignment: .trailing
            )
            .onTapGesture {
                isshowAnalyseList.toggle()
            }
            .sheet(isPresented: $isshowAnalyseList, content: {
                
                SheetWithCloseView {
                    AnalyseListView(analyse: $store.analyse)
                }
                .frame(minWidth: 300, idealWidth: 300, maxWidth: .infinity)
                .padding(EdgeInsets.init(top: 10, leading: 20, bottom: 30, trailing: 40))
                
            })
        }
    }
    
//    public var plotView:some View{
//        TextField("LocalizedStringKey", text: $store.code)
//    }
}


struct ParamView: View {
    @Binding var item:Analyse.Param
    var body :some View{
        TextField(item.name, text: $item.value)
    }
}

struct AnalyseParamView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseParamView(store: AnalyseParam())
    }
}
