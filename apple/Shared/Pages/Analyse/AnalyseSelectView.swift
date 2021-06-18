//
//  AnalyseSelectView.swift
//  apple
//  选择策略view
//  Created by admin on 2021/5/27.
//

import SwiftUI
//import UGSwiftKit



struct AnalyseSelectView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectIndex:Int
    @State var analyses:[Analyse]
    @State var keyword=""
    
    var tableanalyses:[Analyse]{
        if keyword.count>0  {
            return analyses.filter { item in
                item.name.contains(keyword)
            }
        }else{
            return analyses
        }
    }
    
    
    var body: some View {
        VStack{
            TextField("请输入搜索关键字", text: $keyword)
                .searchStype()
                .onTapGesture {
                    
            }
            ScrollView{
                LazyVStack(alignment:.leading, content: {
                    
                    ForEach(0..<tableanalyses.count, id: \.self) { index in
                        
                        AnalyseCell(
                            analyse:tableanalyses[index],
                            isSelect: (index == selectIndex)
                        )

                        .onTapGesture {
                            
                            self.selectIndex = self.analyses.firstIndex(where: { item in
                                item.name == tableanalyses[index].name
                            }) ?? 0
                            presentationMode.wrappedValue.dismiss()
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

struct AnalyseSelectView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseSelectView(selectIndex: .constant(0), analyses: [])
    }
}
