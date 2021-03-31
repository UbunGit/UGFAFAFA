//
//  ArchiveShareCell.swift
//  Share
//
//  Created by admin on 2020/12/16.
//  Copyright © 2020 MBA. All rights reserved.
//

import SwiftUI

struct ArchiveShareCell: View {
    var share:Share
    var body: some View {
        HStack(){
            VStack(alignment: .leading){
                Text("\(share.name)")
                    .font(.system(size: 14))
                    .foregroundColor(Color("background 4"))
                
                Text("\(share.code)")
                    .font(.system(size: 12))
                .foregroundColor(Color("background 4"))
            }
            
            
            Spacer()
            VStack(alignment: .leading){
                Text("持仓:\(share.getAllNum())")
                Text(String(format: "收益:%0.2f", arguments: [share.getIncome()]))
            }
            .foregroundColor(Color("background 4"))
            .font(.system(size: 14))
        }
        .padding(.horizontal)
        
        
    }
}

struct ArchiveShareCell_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveShareCell(share: Share._shares[1])
    }
}
