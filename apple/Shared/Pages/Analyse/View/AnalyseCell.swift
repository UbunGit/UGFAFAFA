//
//  AnalyseCell.swift
//  apple
//
//  Created by admin on 2021/5/27.
//

import SwiftUI


public struct AnalyseCell:View {
    @State var analyse: Analyse
    public var body: some View {
        HStack(alignment:.bottom){
            Text(analyse.name)
            Text(analyse.des ?? "des is null")
        }
        .padding(4)
        .background(Color("Text 2"))
    }
}

struct AnalyseCell_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseCell(analyse: Analyse())
    }
}
