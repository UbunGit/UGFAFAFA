//
//  ZoneView.swift
//  apple
//
//  Created by admin on 2021/7/9.
//

import SwiftUI
struct ZoneView: View {
    @Binding var zones:[ZoneModen]
    var body: some View {
        let rows: [GridItem] =
                Array(repeating: .init(.fixed(44)), count: 2)
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, alignment: .top) {
                ForEach(0..<zones.count, id: \.self) {
                    let item = zones[$0]
                    
                    HStack{
                        Text("\(item.begin)")
                        Text("~")
                        Text("\(item.end)")
                   
                    }
                    .font(.caption)
                    .padding()

                    .frame(height: 44)
                    
                }
            }
        }
    }
}

struct ZoneView_Previews: PreviewProvider {
    static var previews: some View {
        ZoneView(zones: .constant([]))
    }
}
