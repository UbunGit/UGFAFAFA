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
    @Published var isloading = false
    
    public func loaddata(kewword:String?)  {
        isloading = true
        DispatchQueue(label: "python").async {
            do{
                let tudata = try Python.attemptImport("Tusharedata.base")
                let jsdata = tudata.search(keyword:kewword)
                DispatchQueue.main.async {
                    self.bases = try! JSONDecoder().decode([ShareBase].self, from: "\(jsdata)".data(using: .utf8)!)
                    self.isloading = false
                }
            }catch{
                print(error)
                DispatchQueue.main.async {
                    
                    self.isloading = false
                }
            }
            
            
        }
    }
}

struct ShareListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var observed = ShareList()
    
    @Binding var share:ShareBase
    @State var keyword:String = ""
    var body: some View {
        VStack{
            TextField("请输入搜索关键字", text: $keyword)
                .searchStype()
                .onTapGesture {
                    observed.loaddata(kewword: keyword)
                }
            

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

        .loading(isloading: observed.isloading)
    }
}


struct ShareListView_Previews: PreviewProvider {
    static var previews: some View {
        ShareListView(share: .constant(ShareBase()))
    }
}
