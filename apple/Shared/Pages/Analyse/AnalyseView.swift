//
//  AnalyseView.swift
//  apple
//
//  Created by admin on 2021/6/19.
//

import SwiftUI
import UGSwiftKit

struct AnalyseView:View {
    @State var isShowSetting = false
    var body: some View{
        NavigationView{
            GeometryReader(content: { geometry in
                HStack{
                    AnalyseResultView()
                        .frame(width: geometry.size.width)
                }
                
            })
            .navigationTitle("策略")
            .navigationBarItems(trailing:
                                    Image(systemName: "wrench.and.screwdriver")
                                    .onTapGesture {
                                        withAnimation {
                                            isShowSetting.toggle()
                                        }
                                        
                                    }
            )
            .sheet(isPresented: $isShowSetting, content: {
                SheetWithCloseView {
                    AnalyseParamView()
                } 
            })
        }
        
        
    }
}

struct AnalyseView_Previews: PreviewProvider {
    static var previews: some View {
        
        return AnalyseView()
            .preferredColorScheme(.dark)
    }
}
