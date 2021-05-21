//
//  AnalyseListView.swift
//  apple (iOS)
//
//  Created by admin on 2021/5/21.
//

import SwiftUI

class AnalyseList: ObservableObject {
    
    func addSocketon() {
        scokeClient.on("analyse") {  data, ack in

            let er:[ScokeResult?] = data.map { item -> ScokeResult? in

                return try? JSONDecoder().decode(ScokeResult.self, from: item)
         
            }
         
      
           
        }
    }
}

struct AnalyseListView: View {
    @ObservedObject var obser = AnalyseList()
    var body: some View {
        VStack{
            Text("socke链接")
                .onTapGesture {
                    processSocket()
                }
            
            Text("发送消息")
                .onTapGesture {
                    let data = ["name":"haikui"]
                    scokeClient.emit("analyse", data)
                }
            
        }.onAppear(){
            obser.addSocketon()
        }
     
    }
}

struct AnalyseListView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseListView()
    }
}
