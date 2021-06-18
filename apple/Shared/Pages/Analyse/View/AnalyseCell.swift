//
//  AnalyseCell.swift
//  apple
//
//  Created by admin on 2021/5/27.
//

import SwiftUI


public struct AnalyseCell:View {
    
   
    var analyse: Analyse
    var isSelect:Bool
    
    init(analyse:Analyse,isSelect:Bool = false) {
        self.analyse = analyse
        self.isSelect = isSelect
    }
    
    public var body: some View {
        HStack(alignment:.bottom){
            Text("\(analyse.name)")
            Spacer()
            Text(analyse.des ?? "des is null")
        }
        .padding()
        .background(isSelect ? Color("AccentColor").opacity(0.1) : Color("Background 1"))
    }
}

struct AnalyseCell_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseCell(analyse: Analyse())
    }
}
