//
//  AnalyseView.swift
//  apple
//
//  Created by admin on 2021/6/19.
//

import SwiftUI

struct AnalyseView:View {
    @State var isShowSetting = false
    var body: some View{
        NavigationView{
            GeometryReader(content: { geometry in
                HStack{
                    
                    AnalyseResultView()
                        .frame(width: geometry.size.width)
                        .offset(x: isShowSetting ? -geometry.size.width : 0)
                    
                    AnalyseParamView()
                        
                        .frame(width: geometry.size.width)
                        .offset(x: isShowSetting ? -geometry.size.width : 0)
                }
//                .ignoresSafeArea(.all, edges: .bottom)
                
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
        }
        
        
    }
}

struct AnalyseView_Previews: PreviewProvider {
    static var previews: some View {
        
        return AnalyseView()
            .preferredColorScheme(.dark)
    }
}
