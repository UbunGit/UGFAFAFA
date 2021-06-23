//
//  Test.swift
//  apple
//
//  Created by admin on 2021/6/23.
//

import SwiftUI
import UGSwiftKit
import Alamofire

class AnalyseHistory: ObservableObject {
    
    @Published var analyses:[Analyse]
    @Published var historys:[Analyse]
    
    @Published var isloading = false
    var selectIndex:Int{
        didSet{
            if self.selectIndex != -1 {
                self.reqHistorys()
            }
            
        }
    }
    init() {
        self.analyses = []
        self.historys = []
        self.selectIndex = -1
        self.reqAnalyses()
        
    }
    
    func reqAnalyses()  {
        let url = "\(baseurl)/analyses"
        isloading = true
        AF.request(url, method: .get, parameters: nil){ urlRequest in
            urlRequest.timeoutInterval = 5
        }.responseModel([Analyse].self) { result in
            self.isloading = false
            switch result{
            case .success(let result):
                self.analyses = result
                self.selectIndex = 0
                
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func reqHistorys()  {
        if selectIndex>=analyses.count {
            print("selectIndex>=analyses.count")
            return
        }
        let url = "\(baseurl)/analyses/history"
        isloading = true
        AF.request(url, method: .get, parameters: ["name":analyses[selectIndex].name]){ urlRequest in
            
            urlRequest.timeoutInterval = 5
        }.responseModel([Analyse].self) { result in
            self.isloading = false
            switch result{
            case .success(let result):
                self.historys = result
                
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
}
let analyseHistory = AnalyseHistory()

struct AnalyseHistoryView: View {
    @ObservedObject var obser:AnalyseHistory
    init() {
        self.obser = analyseHistory
    }
    var body: some View {
        VStack{
        
            ScrollView{
                LazyVStack(alignment:.leading, content: {
                    
                    ForEach(0..<obser.historys.count, id: \.self) { index in
                        let item = obser.historys[index]
                        VStack(alignment:.leading){
                            HStack{
                                Text(item.name)
                                
                                Spacer()
                                Text(item.changeTime)
                                    .font(.caption2)
                            }
                            .padding([.bottom])
                            
                            
                            Text("\(item.begin)~\(item.end)")
                                .font(.caption2)
                            
                            VStack{
                                
                                ForEach(0..<item.parameter.count, id: \.self) { pindex in
                                    let item = item.parameter[pindex]
                                    HStack{
                                        Text(item.name)
                                        Text(item.value)
                                    }
                                    .font(.caption2)
                                    
                                }
                            }.padding([.bottom])
                            
                            
                            Text(item.codes.joined(separator: ","))
                                .font(.caption2)
                            
                            
                            
                        }
                        .padding()
                        .background(Color("AccentColor").opacity(0.1))
                        
                    }
                })
            }
            .padding()
        }.onAppear(){
            
        }
        
    }
}

struct AnalyseHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseHistoryView()
    }
}
