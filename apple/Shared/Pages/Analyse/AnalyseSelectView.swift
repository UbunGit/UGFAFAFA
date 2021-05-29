//
//  AnalyseSelectView.swift
//  apple
//
//  Created by admin on 2021/5/27.
//

import SwiftUI
import UGSwiftKit



struct AnalyseSelectView: View {
    @Environment(\.presentationMode) var presentationMode
 
    @Binding var analyse:Analyse
    @State var analyses:[Analyse]
    
    var body: some View {
        VStack{
//            TextField("请输入搜索关键字", text: $obser.keyword)
//                .searchStype()
//                .onTapGesture {
//                    obser.loaddata(kewword: obser.keyword)
//                }
            ScrollView{
                LazyVStack(alignment:.leading, content: {
                    ForEach(0..<analyses.count, id: \.self) {
                        let tanalyse = analyses[$0]
                        AnalyseCell(analyse:tanalyse)
                            .padding(/*@START_MENU_TOKEN@*/.all, 2.0/*@END_MENU_TOKEN@*/)
                            .onTapGesture {
                                self.analyse = tanalyse
                                presentationMode.wrappedValue.dismiss()
                            }
                        
                    }
                })
            }
            
           
        }
        
        .padding([.top, .leading],40)
        .onAppear(){

        }
    }
}

struct AnalyseSelectView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseSelectView(analyse: .constant(Analyse()),analyses: [])
    }
}
