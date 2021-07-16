//: A UIKit based Playground for presenting user interface

import UIKit
import SwiftUI
import UGSwiftKit
import PlaygroundSupport

class SelectETF:ObservableObject{
    @Published var etfs:[ETFBasic] = []
    
    func updateData()  {
//        etfs = EFTBase.
    }
}

struct SelectETFView: View {
    @ObservedObject var obsee = SelectETF()
    @State var keyword = ""
    var body: some View {
        VStack{
            TextField("请输入搜索关键字", text: $keyword)
//                .searchStype()
                .onTapGesture {
                    
                }
            ScrollView{
                LazyVStack(alignment:.leading, content: {

                    ForEach(0..<obsee.etfs.count, id: \.self) { index in

                        ETFCell(
                            etf: obsee.etfs[index]
                        )

                        .onTapGesture {

                        }

                    }
                })
            }
        }
        
        .padding()
        .onAppear(){
            
        }
        .onDisappear(){
            
        }
    }
}

struct ETFCell:View{
    
    @State var etf:ETFBasic
    var body: some View{
        Text(etf.code)
        Text(etf.name)
    }
}

PlaygroundPage.current.setLiveView(SelectETFView())
