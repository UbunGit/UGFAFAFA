//
//  CommitView.swift
//  apple
//
//  Created by admin on 2021/6/23.
//

import SwiftUI

struct CommitView: View {
    @State var foregroundColor = Color("Background 1")
    @State var background = (Color("AccentColor"))
    var body: some View {
        HStack{
            Spacer()
                Text("确认")
            Spacer()
        }
        .foregroundColor(foregroundColor)
        .frame( height: 44)
        .background(background)
        .cornerRadius(8)
    }
}

struct CommitView_Previews: PreviewProvider {
    static var previews: some View {
        CommitView()
    }
}
