//
//  AnalyseListView.swift
//  apple (iOS)
//
//  Created by admin on 2021/5/21.
//

import SwiftUI
import UGSwiftKit

struct Analyse:Codable {
    
    var params:[Param] = []
    var name:String?
    
    struct Param:Codable {
        var name:String?
        var key:String?
        var value:String?
    }
    
}

class AnalyseParam: ObservableObject {
    
    @Published var analyses:[Analyse] = []
    @Published var analyse:Analyse?

}

struct AnalyseParamView: View {
    @ObservedObject var obser = AnalyseParam()
    @State var begin:Date = Date()
    @State var end:Date = Date()
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            HStack{
                Text(obser.analyse?.name ?? "选择策略")
                    .font(.title)
                Image(systemName: "chevron.forward")
            }
            Divider()
            Section{
                Text("公共参数")
                    .font(.title2)
                commonParamView
            }
            Section{
                Text("策略参数")
                    .font(.title2)
                ownedParamView
            }
            
        }
        

        .textFieldStyle(PlainTextFieldStyle())
        .padding()
        .background(Color.white)
        .onAppear(){
            
        }
    }
    
    /// 公共的参数view
    var commonParamView:some View{
        VStack(alignment: .leading, spacing: 8){
   
            DatePicker(
                       selection: $begin,
                       displayedComponents: [.date]){
                Text("开始时间")
                    .padding()
            }
            
            DatePicker(
                selection: $end,
                displayedComponents: [.date]){
                Text("结束时间")
                    .padding()
            }

            HStack{
                Text("股票列表")
                    .padding()
                TextField("ee", text: .constant("ee"))
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 0.5)
                                   .stroke(Color("Text 2"), lineWidth: 1))
            }
            
        }
     
    }
    
    /// 每个策略自己所需的参数
    var ownedParamView:some View{
        HStack{
            ForEach(0..<obser.analyse?.params.count, id:\.self) {
                
                HStack{
                    Text(obser.analyses.name)
                }
            }
            
        }
    }
}

struct AnalyseParamView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseParamView()
    }
}
