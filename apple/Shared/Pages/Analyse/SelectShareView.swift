//
//  SelectShareView.swift
//  apple
//  选择股票列表view
//  Created by admin on 2021/5/29.
//

import SwiftUI
import Alamofire
class SelectShare: ObservableObject{
    
    @Published var shares:[GroupShare] = []
    @Published var selects:[String] = []
    init() {
        loaddata()
    }
    
    func loaddata()  {
        let url = "\(baseurl)/base"
        
        AF.request(url, method: .get, parameters: nil){ urlRequest in
            urlRequest.timeoutInterval = 5
        }.responseModel([GroupShare].self) { result in
            switch result{
            case .success(let result):
                self.shares = result
                
            case .failure(let error):
                print("\(error)")
            }
        }
        
    }
}

extension Array{
    
    func groupby<T>(keyPath:KeyPath<Element, T>) -> Set<T> {
        Set(self.map{
            return $0[keyPath: keyPath]
        })
    }
}

let selectShare = SelectShare()

struct SelectShareView: View {
    
    @ObservedObject var obser = selectShare
    @Binding var selects:[String]
    @State var keyword = ""
    
    var searchShares:[GroupShare]{
        if keyword.count>0  {
            return  obser.shares.filter { item in
                item.code.contains(keyword) || item.name.contains(keyword)
            }
        }else{
            return obser.shares
        }
        
    }

    var body: some View {
        VStack{
            TextField("请输入搜索关键字", text: $keyword)
                .searchStype()
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach((0..<searchShares.count), id: \.self) {
                        let share = searchShares[$0]
                        let isSelect = obser.selects.contains(share.code)
                        SelectShareCell(share: share,isSelect: isSelect)
                            .onTapGesture {
                                if (isSelect){
                                    obser.selects.removeAll { item in
                                        item == share.code
                                    }
                                }else{
                                    obser.selects.append(share.code)
                                }
                                
                            }
                    }
                }
            }
            
        }
        .padding()
        .onAppear(){
            
            obser.selects = selects
        }
        .onDisappear(){
            selects = obser.selects
        }
    }
    
}

struct SelectShareCell: View {
    
    init(share:GroupShare,isSelect:Bool = false) {
        self.share = share
        self.isSelect = isSelect
    }
    let share:GroupShare
    let isSelect:Bool
    var body: some View {
        HStack{
            VStack(alignment:.leading){
                VStack(alignment:.leading){
                    HStack{
                        Text("\(share.name)")
                        Text("\(share.code)")
                    }
                    HStack{
                        Text("\(share.area)")
                        Text("\(share.industry)")
                        Text("\(share.market)")
                    }
                    .font(.caption2)
                    .foregroundColor(Color("Text 3"))
                }
                
                
            }
            Spacer()
            
            if isSelect {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color("AccentColor"))
                    .font(.title)
            }
            
        }
        .padding()
        .background(isSelect ? Color("AccentColor").opacity(0.1) : Color("Background 1"))
    }
}

struct SelectShareView_Previews: PreviewProvider {
    static var previews: some View {
        SelectShareView(selects: .constant([]))
    }
}
