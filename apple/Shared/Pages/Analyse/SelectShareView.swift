//
//  SelectShareView.swift
//  apple
//
//  Created by admin on 2021/5/29.
//

import SwiftUI
import Alamofire
class SelectShare: ObservableObject{
    
    @Published var shares:[GroupShare] = []
    @Published var selects:[String] = []
    
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

struct SelectShareView: View {
    @ObservedObject var obser = SelectShare()
    @Binding var selects:[String]
    var body: some View {
        HStack{
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach((0..<obser.shares.count), id: \.self) {
                        
                        let share = obser.shares[$0]
                        let isSelect = obser.selects.contains(share.code)
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
                                Divider()
                               
                            }
                            Spacer()
                            
                            if isSelect {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color("AccentColor"))
                                    .font(.title)
                            }
                            
                        }
                        .onTapGesture {
                            if (isSelect){
                                obser.selects.removeAll { item in
                                    item == share.code
                                }
                            }else{
                                obser.selects.append(share.code)
                            }
                            
                        }
                        .padding(4)
                       
                    }
                }
            }

            
        }
        .padding()
        .onAppear(){
            obser.loaddata()
            obser.selects = selects
        }
        .onDisappear(){
            selects = obser.selects
        }
    }
    
}

struct SelectShareView_Previews: PreviewProvider {
    static var previews: some View {
        SelectShareView(selects: .constant([]))
    }
}
