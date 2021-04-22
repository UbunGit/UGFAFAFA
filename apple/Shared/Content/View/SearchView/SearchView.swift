//
//  SearchView.swift
//  apple (iOS)
//
//  Created by admin on 2021/4/3.
//

import SwiftUI

struct SearchView: View {
    
    @Binding var searchText:String
    @State var format:StringLenFormatter = StringLenFormatter(maxlen: 3)!
    
    @ViewBuilder
    var body: some View {
        content
    }
    
    var content:some View{
        HStack{
            Image(systemName: "magnifyingglass")
                .padding(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
         
            
            TextField("Search", value: $searchText, formatter: format, onCommit: {
           
            })
            .textFieldStyle(PlainTextFieldStyle())
            .padding(.vertical, 8)
            
        }
        .font(.title3)
        
        .background(Color("Background 1"))
        .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .padding(.vertical, 1)
     
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchText: .constant(""))
            .background(Color("Background 4"))
            
    }
}
