//
//  AnalyseListView.swift
//  apple (iOS)
//  策略参数view
//  Created by admin on 2021/5/21.
//

import SwiftUI
import UGSwiftKit
import Alamofire


class AnalyseParam: ObservableObject {
    
    @Published var analyses:[Analyse]
    @Published var selectIndex = 0
    @Published var isloading = false
    init() {
        analyses = []
    }
    
    func loaddata()  {
        let url = "\(baseurl)/analyses"
        isloading = true
        AF.request(url, method: .get, parameters: nil){ urlRequest in
            urlRequest.timeoutInterval = 5
        }.responseModel([Analyse].self) { result in
            self.isloading = false
            switch result{
            case .success(let result):
                self.analyses = result
                
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
}


let analyseParam: AnalyseParam = AnalyseParam()

struct AnalyseParamView: View {
    
    @ObservedObject var obser:AnalyseParam
    @State var begin:Date = Date()
    @State var end:Date = Date()
    
    @State var isSheetSelectAnalyse = false
    @State var isSheetSelectShare = false
    /// 选中的策略
    var selectAnalyses:Analyse{
        if obser.analyses.count > obser.selectIndex{
            return obser.analyses[obser.selectIndex]
        }else{
            return Analyse()
        }
    }
    
    init() {
        self.obser = analyseParam
    }
    
    var codes:Binding<String>{
        Binding<String>(
            get:{
                
                selectAnalyses.codes.joined(separator: ",")
            },
            
            set:{
                let codes = $0.components(separatedBy: ",")
                obser.analyses[obser.selectIndex].codes = codes
            }
        )
    }
    
    
    var body: some View {
        
        VStack(alignment:.leading){
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment:.leading){
                    HStack(){
                        Text(selectAnalyses.name)
                            .font(.title)
                        Text(" \(selectAnalyses.des ?? "")")
                            .font(.title)
                        Image(systemName: "chevron.forward")
                    }
                    .sheet(isPresented: $isSheetSelectAnalyse, content: {
                        SheetWithCloseView {
                            
                            AnalyseSelectView(selectIndex: $obser.selectIndex, analyses: obser.analyses)
                        }
                        
                    })
                    .onTapGesture(perform: {
                        isSheetSelectAnalyse = true
                    })
                    Divider()
                }
                .padding()
                VStack(alignment:.leading){
                    
                    
                    
                    VStack(alignment:.leading){
                        Text("公共参数")
                            .font(.title2)
                        commonParamView
                    }
                    .padding()
                    
                    VStack(alignment:.leading){
                        Text("策略参数")
                            .font(.title2)
                        ownedParamView
                    }
                    .padding()
                }
                .frame( minWidth: 0, maxWidth: .infinity)
                .textFieldStyle(PlainTextFieldStyle())
                
                Spacer()
                CommitView()
                    .onTapGesture {
                        var data = selectAnalyses
                        data.begin = begin.toString("yyyyMMdd") ?? "20160101"
                        data.end = end.toString("yyyyMMdd") ?? ""
                        let json = try? JSONEncoder().encode(data)
                        scokeClient.emit("analyse1",with: [json as Any])
                    }
                    .padding()
                
            }
           
        }
        .loading(isloading: obser.isloading)
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
               
            }
            
            DatePicker(
                selection: $end,
                displayedComponents: [.date]){
                Text("结束时间")
                
            }
          
            
            VStack(alignment:.leading){
          
                HStack{
                    Text("股票列表")
                     
                    TextEditor(text: codes)
                        .frame(minHeight: 40, maxHeight: .infinity, alignment: .topLeading)
                        
                        .overlay(RoundedRectangle(cornerRadius: 0.1)
                                       .stroke(Color("Text 2"), lineWidth: 1))
                        .padding()
                    
                }
                
                .overlay(
                    Image(systemName: "plus.circle")
                        .padding()
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    ,
                    alignment: .topTrailing
                )
                .sheet(isPresented: $isSheetSelectShare, content: {
                    SheetWithCloseView {
                        
                        SelectShareView(selects: $obser.analyses[obser.selectIndex].codes)
                    }
                    
                })
                .onTapGesture {
                    isSheetSelectShare = true
                }
            }
        }
        
    }
    
    /// 每个策略自己所需的参数
    var ownedParamView:some View{
        
        return  LazyVStack(content: {
            ForEach((0..<selectAnalyses.parameter.count), id: \.self) {index in
                
                HStack{
                    
                    Text("\(selectAnalyses.parameter[index].name)")
                        .padding()
                    TextField("ee", text:$obser.analyses[obser.selectIndex].parameter[index].value)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 0.5)
                                    .stroke(Color("Text 2"), lineWidth: 1))
                }
            }
        })
        
    }
   

}

struct InputParam:View {
    @Binding var param:Analyse.Parameter
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
        
        return AnalyseParamView()
            .preferredColorScheme(.dark)
    }
}
