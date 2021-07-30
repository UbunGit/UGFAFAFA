//
//  DataManageView.swift
//  apple (iOS)
//
//  Created by admin on 2021/7/17.
//

import SwiftUI
struct DataManageModel {
    var name:String = ""
    var icon:String = ""
    
    var view:AnyView?
    
    static var datas:[DataManageModel] = [
        .init(name: "数据更新",icon: "🐶", view: AnyView( UpdateSeverDataView())),
        .init(name: "测试",icon: "🐱")
    ]
    
}
class DataManage: ObservableObject {
    
    @Published var datas:[DataManageModel] = DataManageModel.datas
}

struct DataManageView: View {
    @StateObject var obser = DataManage()
    var body: some View {
        NavigationView{
            
            ScrollView(.vertical) {
                
                let rows: [GridItem] =
                        Array(repeating: .init(.fixed(10)), count: 1)
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, alignment: .top) {
                        ForEach((0..<obser.datas.count), id: \.self) { index in
                            let item = obser.datas[index]
                            
                            if item.view != nil{
                                NavigationLink(destination:  item.view){
                                    
                                    DataManageViewCell(item: item)
                                }
                                
                            }else{
                                DataManageViewCell(item: item)
                            }
                           
                           
                            
                            
                        }
                    }
                }

            }
            .padding()
            .navigationTitle("数据管理")
        }
    }
}
struct DataManageViewCell:View {
    @State var item:DataManageModel
    var body:some View{
        VStack{
            Text(item.icon)
                .padding([.bottom], 4)
            Text(item.name)
                .font(.caption)
        }
        .frame(width:80,height:80)
        .overlay(
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(Color("Background 2"), lineWidth: 1)
        )
    }
    
}

struct DataManageView_Previews: PreviewProvider {
    static var previews: some View {
        DataManageView()
    }
}
