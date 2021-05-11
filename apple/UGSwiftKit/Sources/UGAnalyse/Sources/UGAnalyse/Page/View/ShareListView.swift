//
//  ShareListView.swift
//  UGSwiftKit
//
//  Created by admin on 2021/5/10.
//

import SwiftUI
import PythonKit



class ShareList: ObservableObject {
    
    @Published var bases:[ShareBase] = []
    
    
    
    public func loaddata(kewword:String?)  {
        let tudata = Python.import("Tusharedata.base")
        let jsdata = tudata.search(keyword:kewword)
        bases = try! JSONDecoder().decode([ShareBase].self, from: "\(jsdata)".data(using: .utf8)!)
       
        print(bases)
    }
}

struct ShareListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var observed = ShareList()
    
    @Binding var share:ShareBase
    var body: some View {
        
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(0..<observed.bases.count, id: \.self) {
                    let base = observed.bases[$0]
                    HStack{
                        Text(base.name)
                        Text(base.code)
                        Text(base.industry)
                    }
                    .padding(/*@START_MENU_TOKEN@*/.all, 2.0/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        share = base
                        presentationMode.wrappedValue.dismiss()
                    }
                } 
            }
        }
        .frame( minHeight: 300, idealHeight: 300, maxHeight: .infinity, alignment: .center)
        .onAppear(){
            observed.loaddata(kewword: "思")
            print(observed.bases.count)
        }
    }
}


struct ShareListView_Previews: PreviewProvider {
    static var previews: some View {
        ShareListView(share: .constant(ShareBase()))
    }
}
