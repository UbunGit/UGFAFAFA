//
//  UpdateBaseView.swift
//  apple (iOS)
//
//  Created by admin on 2021/7/17.
//

import SwiftUI
import UGSwiftKit

let notif = NotificationCenter.default

struct UpdateDataModen {
    
    var name:String
    var end:()->(String?)
    var closures:()->()
    var endStr:String{
        end() ?? "--"
    }
    
    static func list() -> [UpdateDataModen] {
        [
            UpdateDataModen(name: "股票列表", end: {
                StockBasic.last(column: "changeTime", isDesc: true)?.changeTime
            }, closures: {
                updateStockBase { error in
                    if error != nil {
                        notif.alert(error?.msg ?? "error")
                    }
                    notif.post(name: NSNotification.nf_updatelist, object: nil)
                   
                }
            }),
            
            UpdateDataModen(name: "ETF列表", end: {
                ETFBasic.last(column: "changeTime", isDesc: true)?.changeTime
            }, closures: {
                updateETFBase { error in
                    if error != nil {
                        notif.alert(error?.msg ?? "error")
                    }
                   
                    notif.post(name: NSNotification.nf_updatelist, object: nil)
                   
                }
            })
        ]
    }
}


class UpdateSeverData: ObservableObject {
    @Published var updatelist = UpdateDataModen.list()
    init() {
        
        notif.addObserver(self, selector: #selector(updatelistData), name: NSNotification.nf_updatelist, object: nil)
    }
    @objc func updatelistData() {
        updatelist = UpdateDataModen.list()
    }
}

struct UpdateSeverDataView: View {
    @StateObject var obser = UpdateSeverData()
    @State var status = "gengx"
    @State var isloading=false
    var body: some View {
        VStack{
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(0..<obser.updatelist.count, id: \.self) { index in
                        VStack(alignment:.leading){
                            Text("\(obser.updatelist[index].name)")
                            Text("最后更新时间：\(obser.updatelist[index].endStr)")
                                .font(.caption2)
                        }
                        .padding()
                        .onTapGesture {
                            obser.updatelist[index].closures()
                            
                        }
                        
                    }
                }
            }
            
            
        }
        .loading(isloading: isloading)
    }
    
    func updateBase(finesh:@escaping (_ finesh:BaseError?)->()){
        isloading = true
        var werror:BaseError?
        let group = DispatchGroup()
        group.enter()
        updateStockBase { error in
            if error != nil {
                werror = error
            }
            group.leave()
        }
        
        group.enter()
        updateETFBase { error in
            if error != nil {
                werror = error
            }
            group.leave()
        }
       
        group.notify(queue: .main) {
            print("all requests come back")
            finesh(werror)
            isloading = false

        }

        
    }
   
}

struct UpdateBaseView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateSeverDataView()
    }
}
