//
//  StoreCell.swift
//  Share
//
//  Created by admin on 2020/12/18.
//  Copyright © 2020 MBA. All rights reserved.
//

import SwiftUI

struct SroreCell: View {
    
    #if os(iOS)
    var cornerRadius: CGFloat = 22
    #else
    var cornerRadius: CGFloat = 10
    #endif
    var store:Store
    @Binding var price:Float
    
    var body: some View {
        VStack {
            HStack{
                VStack(alignment: .center){
                    Progress( percent: getraido())
                        .frame(width: 44, height: 44, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                      
                    Text("收益\n\(getbandles() ,specifier: "%0.2f")")
                        .font(.system(size: 10))
                        .foregroundColor(getbackground())
                }
                
                
                VStack(alignment: .leading){
                    Text("单价：\(store.price ,specifier: "%0.3f")")
                    Text("数量：\(store.num)")
                    Text("成本：\(store.getAllprice() ,specifier: "%0.2f")")
                    if(store.day != nil){
                        Text("买入时间：\(store.day ?? "--")")
                    }
                    if(store.outday != nil){
                        Text("买出时间：\(store.outday ?? "--")")
                        Text("买出价格：\(store.outprice ?? 0.00,specifier: "%0.3f")")
                    }
                    
                }
               
                .font(.system(size: 10))
                
            }
            
        }
        .foregroundColor(.white)
        .padding(.all)
        .frame( minHeight: 120, idealHeight: 120, maxHeight: .infinity, alignment: .center)
        
        .background(getbackground().opacity(0.2))
        
        .cornerRadius(cornerRadius)
        .shadow(color: Color("shadow").opacity(0.3), radius: 20, x: 0, y: 10)
        
    }
    
    // 获取收益
    func getbandles() -> Float {
        if store.state == 1 {
            return (Float(store.num)*((store.outprice ?? 0.00) - store.price))-(store.fee ?? 0.00)
        }else{
            return Float(store.num)*(price - store.price)
        }
        
    }
    // 获取收益比率
    func getraido() -> Float {
        var raido:Float = 0
        if store.state == 1 {
            raido = ((store.outprice ?? 0.00)/store.price)*100
        }else{
            raido = (price/store.price)*100
        }
        return raido
    }
    func getbackground() -> Color {
        if store.state == 1 {
            return Color("Background 5")
        }else{
            return (store.price<price) ? Color.red:Color.green
        }
    }
}

struct StoreCell_Previews: PreviewProvider {
    static var previews: some View {
        SroreCell(store:Store._stores[0], price: .constant(1.00))
    }
}
