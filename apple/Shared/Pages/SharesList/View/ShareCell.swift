//
//  ArchiveShareCell.swift
//  Share
//
//  Created by admin on 2020/12/16.
//  Copyright © 2020 MBA. All rights reserved.
//

import SwiftUI

struct ShareCell: View {
    var share:Share
    var body: some View {
        HStack(alignment: .center){
            VStack(alignment: .leading){
                Text("\(share.name)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color.primary)
                
                Text("\(share.code)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 2)
           
            }
            Spacer(minLength: 0)
            VStack(alignment: .leading){
                Text("持仓:\(share.getAllNum(state: 0))")
                Text(String(format: "收益:%0.2f", arguments: [share.getIncome()]))
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.bottom, 2)
        }
      
        
        
    }
}

struct ArchiveShareCell_Previews: PreviewProvider {
    static var previews: some View {
        ShareCell(share: Share._shares[1])
            .background(Color("Background 1"))
    }
    
}
