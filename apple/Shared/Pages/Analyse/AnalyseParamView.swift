//
//  AnalyseListView.swift
//  apple (iOS)
//
//  Created by admin on 2021/5/21.
//

import SwiftUI
import UGSwiftKit
import Alamofire

struct Analyse:Codable {
    
    var params:[Param] = []
    var name:String = ""
    
    struct Param:Codable {
        var name:String = ""
        var key:String = ""
        var value:String = ""
        
        static var _debug = Param(name: "均线", key:"ma" , value: "5")
    }
    
    static var _debug = Analyse(params: [Param._debug], name: "测试")
    
}

class AnalyseParam: ObservableObject {
    
    @Published var analyses:[Analyse] = []
    @Published var analyse:Analyse = Analyse()
    
    func loaddata()  {
        let url = "http://127.0.0.1:5000/analyses"
     
        AF.request(url, method: .get, parameters: nil){ urlRequest in
            urlRequest.timeoutInterval = 5
        }.responseModel([Analyse].self) { result in
            switch result{
            case .success(let result):
                self.analyses = result
                self.analyse = self.analyses.first ?? Analyse()
            case .failure(let error):
                print("\(error)")
            }
        }
        
    }

}

struct AnalyseParamView: View {
    
    @ObservedObject var obser = AnalyseParam()
    @State var begin:Date = Date()
    @State var end:Date = Date()
   
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            HStack{
                Text(obser.analyse.name)
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
            submit
            
        }
        

        .textFieldStyle(PlainTextFieldStyle())
        .padding()
        .background(Color.white)
        .onAppear(){
            obser.loaddata()
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
     
        return  LazyVStack(content: {
            ForEach((0..<obser.analyse.params.count), id: \.self) {index in
           
                HStack{
               
                    Text("\(obser.analyse.params[index].name)")
                        .padding()
                    TextField("ee", text:$obser.analyse.params[index].value)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 0.5)
                                       .stroke(Color("Text 2"), lineWidth: 1))
                }
            }
        })

    }
    
    var submit:some View{
        HStack{
            Text("确认").onTapGesture {
                print("\(obser.analyse)")
            }
        }
    }
}
struct InputParam:View {
    @Binding var param:Analyse.Param
    var body:some View{
        
        HStack{
            
            Text("param?.name")
                .padding()
            TextField("ee", text:$param.value)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 0.5)
                               .stroke(Color("Text 2"), lineWidth: 1))
        }
    }
}

struct AnalyseParamView_Previews: PreviewProvider {
    static var previews: some View {
        
        let analyseParam = AnalyseParam()
        analyseParam.analyses = [Analyse._debug]
        analyseParam.analyse = analyseParam.analyses.first!
        return AnalyseParamView(obser: analyseParam)
    }
}
