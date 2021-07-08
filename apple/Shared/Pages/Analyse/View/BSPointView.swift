//
//  BSPointView.swift
//  apple
//
//  Created by admin on 2021/7/8.
//

import SwiftUI

struct BSPointView: View {
    @Binding var bspoint:[BSModen]
    var body: some View {
        let rows: [GridItem] =
                Array(repeating: .init(.fixed(44)), count: 2)
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, alignment: .top) {
                ForEach(0..<bspoint.count, id: \.self) {
                    let item = bspoint[$0]
                    
                    HStack{
                        Text(item.date)
                        Text((item.type==1) ? "买入" : "卖出")
                        Text("\(item.count)")
                        Text("价格：\(item.price)")
                    }
                    .font(.caption)
                    .padding()
                    .background(item.type==1 ? Color.red.opacity(0.1) : Color.green.opacity(0.1))
                    .frame(height: 44)
                    
                }
            }
        }
    }
}

struct BSPointView_Previews: PreviewProvider {
    static var previews: some View {
        BSPointView(bspoint: .constant([]))
    }
}
