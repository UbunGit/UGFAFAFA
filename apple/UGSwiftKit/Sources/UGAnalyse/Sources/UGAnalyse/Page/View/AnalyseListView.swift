//
//  SwiftUIView.swift
//  
//
//  Created by admin on 2021/5/11.
//

import SwiftUI
import PythonKit
class AnalyseList: ObservableObject {
    
    @Published var analyses:[Analyse] = []
    @Published var isloading = false
    public func loaddata(kewword:String?)  {
        isloading = true
        DispatchQueue(label: "python").async {
            do{
                let analyse = try Python.attemptImport("Analyse")
                let jsdata = analyse.analyses()
                
                DispatchQueue.main.async {
                    self.analyses = try! JSONDecoder().decode([Analyse].self, from: "\(jsdata)".data(using: .utf8)!)
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
struct AnalyseListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var observed = AnalyseList()
    @Binding var analyse:Analyse
    @State var keyword:String = ""
    
    var body: some View {
        VStack{
            TextField("请输入搜索关键字", text: $keyword)
                .searchStype()
                .onTapGesture {
                    observed.loaddata(kewword: keyword)
                }
            ScrollView{
                LazyVStack(content: {
                    ForEach(0..<observed.analyses.count, id: \.self) {
                        let tanalyse = observed.analyses[$0]
                        AnalyseCell(analyse:tanalyse)
                            .padding(/*@START_MENU_TOKEN@*/.all, 2.0/*@END_MENU_TOKEN@*/)
                            .onTapGesture {
                                analyse = tanalyse
                                presentationMode.wrappedValue.dismiss()
                            }
                        
                    }
                })
            }
           
        }
        .frame( minHeight: 300, idealHeight: 300, maxHeight: .infinity, alignment: .center)
        .loading(isloading: observed.isloading)
        .onAppear(){
            observed.loaddata(kewword: "")
        }
    }
   
    
    
}

public struct AnalyseCell:View {
    @State var analyse: Analyse
    public var body: some View {
        HStack{
            Text(analyse.name)
            Text(analyse.des ?? "des is null")
        }
        .padding(4)
    }
}

struct AnalyseList_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseListView(analyse: .constant(Analyse()))
    }
}
