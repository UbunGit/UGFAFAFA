//
//  AnalyseListView.swift
//  apple (iOS)
//
//  Created by admin on 2021/5/21.
//

import SwiftUI
import UGSwiftKit
import Alamofire


class AnalyseParam: ObservableObject {
    
    @Published var analyses:[Analyse] = []
    @Published var analyse:Analyse = Analyse()
    
    func loaddata()  {
        let url = "\(baseurl)/analyses"
     
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
   
    @State var isSheetSelectAnalyse = false
    @State var isSheetSelectShare = false
    
    var codes:Binding<String>{
        Binding<String>(
            get:{
                obser.analyse.codes.joined(separator: ",")
            },
            
            set:{
                let codes = $0.components(separatedBy: ",")
                obser.analyse.codes = codes
            }
        )
    }
    
   
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            HStack{
                Text(obser.analyse.name)
                    .font(.title)
                Text(" \(obser.analyse.des ?? "")")
                    .font(.title)
                Image(systemName: "chevron.forward")
            }
            .sheet(isPresented: $isSheetSelectAnalyse, content: {
                SheetWithCloseView {
                    
                    AnalyseSelectView(analyse: $obser.analyse, analyses: obser.analyses)
                }
                
            })
            .onTapGesture(perform: {
                isSheetSelectAnalyse = true
            })
           
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
            processSocket()
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
                TextField("股票列表", text: codes)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 0.5)
                                   .stroke(Color("Text 2"), lineWidth: 1))
            }
            .overlay(
                Image(systemName: "plus.circle")
                    .padding()
                ,
                alignment: .trailing
            )
            .sheet(isPresented: $isSheetSelectShare, content: {
                SheetWithCloseView {
                    
                    SelectShareView(selects: $obser.analyse.codes)
                }
                
            })
            .onTapGesture {
                isSheetSelectShare = true
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
        GeometryReader(content: { geometry in
            HStack{
                Text("确认").onTapGesture {
                    obser.analyse.begin = begin.toString("yyyyMMdd") ?? "20160101"
                    obser.analyse.end = end.toString("yyyyMMdd") ?? ""
                    let json = try? JSONEncoder().encode(obser.analyse)
                    scokeClient.emit("analyse1",with: [json as Any])
                }
                .foregroundColor(Color("Background 1"))
                .padding()
                .frame(width: geometry.size.width-20, height: 44, alignment: .center)
                .background(Color("AccentColor"))
                .cornerRadius(8)
 
            }
        })
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
