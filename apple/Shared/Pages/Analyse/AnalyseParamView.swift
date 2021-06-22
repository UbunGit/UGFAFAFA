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
        loaddata()
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
    
    var codes:Binding<[Analyse.Share]>{
        Binding<[Analyse.Share]>(
            get:{
                
                selectAnalyses.codes
            },
            
            set:{
                obser.analyses[obser.selectIndex].codes = $0
            }
        )
    }
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8){
            HStack{
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
        .loading(isloading: obser.isloading)
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
            
            VStack{
                Text("股票列表")
                    .padding()
                
                let rows: [GridItem] =
                        Array(repeating: .init(.fixed(20)), count: 2)
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, alignment: .top) {
                        ForEach((0...79), id: \.self) {
                            let codepoint = $0 + 0x1f600
//                            let codepointString = String(format: "%02X", codepoint)
//                            Text("\(codepointString)")
//                                .font(.footnote)
                            let emoji = String(Character(UnicodeScalar(codepoint)!))
//
                            HStack{
                                Text("\(emoji)")
                                //                                .font(.largeTitle)
                            }.padding()
                          
                        }
                    }
                }
                   
            }
//            .overlay(
//                Image(systemName: "plus.circle")
//                    .padding()
//                ,
//                alignment: .trailing
//            )
//            .sheet(isPresented: $isSheetSelectShare, content: {
//                SheetWithCloseView {
//
//                    SelectShareView(selects: $obser.analyses[obser.selectIndex].codes)
//                }
//
//            })
//            .onTapGesture {
//                isSheetSelectShare = true
//            }
            
        }
        
    }
    
    /// 每个策略自己所需的参数
    var ownedParamView:some View{
        
        return  LazyVStack(content: {
            ForEach((0..<selectAnalyses.params.count), id: \.self) {index in
                
                HStack{
                    
                    Text("\(selectAnalyses.params[index].name)")
                        .padding()
                    TextField("ee", text:$obser.analyses[obser.selectIndex].params[index].value)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 0.5)
                                    .stroke(Color("Text 2"), lineWidth: 1))
                }
            }
        })
        
    }
    
    /// 确认按钮
    var submit:some View{
        GeometryReader(content: { geometry in
            HStack{
                Text("确认")
                    .foregroundColor(Color("Background 1"))
                    .padding()
                    .frame(width: geometry.size.width-20, height: 44, alignment: .center)
                    .background(Color("AccentColor"))
                    .cornerRadius(8)
                    .onTapGesture {
                        var data = selectAnalyses
                        data.begin = begin.toString("yyyyMMdd") ?? "20160101"
                        data.end = end.toString("yyyyMMdd") ?? ""
                        let json = try? JSONEncoder().encode(data)
                        scokeClient.emit("analyse1",with: [json as Any])
                    }
                
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
        
        return AnalyseParamView()
            .preferredColorScheme(.dark)
    }
}
