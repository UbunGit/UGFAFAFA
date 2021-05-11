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
    
    public func loaddata()  {
        
        let analyse = Python.import("Analyse")
        let jsdata = analyse.analyses()
        analyses = try! JSONDecoder().decode([Analyse].self, from: "\(jsdata)".data(using: .utf8)!)
    }
    
}
struct AnalyseListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var observed = AnalyseList()
    @Binding var analyse:Analyse
    
    var body: some View {
        ScrollView{
            LazyVStack(content: {
                ForEach(0..<observed.analyses.count, id: \.self) {
                    let tanalyse = observed.analyses[$0]
                    AnalyseCell(analyse:tanalyse)
                        .onTapGesture {
                            analyse = tanalyse
                            presentationMode.wrappedValue.dismiss()
                        }
                    
                }
            })
            Text("ee")
        }
        .onAppear(){
            observed.loaddata()
        }
    }
    
    
}

struct AnalyseCell:View {
    @State var analyse: Analyse
    var body: some View {
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
