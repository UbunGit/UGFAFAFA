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
    @State var isShowHistory = false
  
    @State var history:Analyse = Analyse()
    
    
    var body: some View{
        NavigationView{
            
            GeometryReader(content: { geometry in
                HStack{
                    
                    AnalyseResultView(historyId: $history.id, codes: $history.codes)
                        .frame(width: geometry.size.width)
                }
                
            })
            .navigationTitle("策略")
            .navigationBarItems(trailing:
                                    HStack{
                                        Image(systemName: "wrench.and.screwdriver")
                                            .onTapGesture {
                                                withAnimation {
                                                    isShowSetting.toggle()
                                                }
                                                
                                            }
                                            .sheet(isPresented: $isShowSetting, content: {
                                                SheetWithCloseView {
                                                    AnalyseParamView()
                                                }
                                            })
                                        
                                        Image(systemName: "plus.circle")
                                            .onTapGesture {
                                                withAnimation {
                                                    isShowHistory.toggle()
                                                }
                                                
                                            }
                                            .padding([.leading],10)
                                            .sheet(isPresented: $isShowHistory, content: {
                                                SheetWithCloseView {
                                                    AnalyseHistoryView(history: $history)
                                                }
                                            })
                                        
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
