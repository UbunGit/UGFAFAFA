//
//  AnalyseView.swift
//  apple
//
//  Created by admin on 2021/6/7.
//

import SwiftUI

struct AnalyseView: View {
    @State var ismenu = true
    var body: some View {
        
        GeometryReader(content: { geometry in
            HStack{
                AnalyseResultView()
                    .frame(width: ismenu ? geometry.size.width*0.5 : geometry.size.width)
                    .onTapGesture {
                        withAnimation {
                            ismenu.toggle()
                        }
                    }
                Spacer()
                AnalyseParamView()
                    .frame(width: ismenu ? geometry.size.width*0.5 : 0)
            }
        })
        
    }
}

struct AnalyseView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseView()
    }
}
