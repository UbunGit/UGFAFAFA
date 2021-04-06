//
//  SwiftUIView.swift
//  apple
//
//  Created by admin on 2021/4/1.
//

import SwiftUI

struct Segmented:Codable , Identifiable {
    var id: Int
    var title:String?
    var icon:String?
}

struct SegmentedView: View {
    
    @State var tabs:[Segmented]
    @Binding var selectTab:Segmented?
    @State var animation:Bool = false
    @State var action: (_ tab:Segmented?) -> Void
    var body: some View {
        content
            .animation(animation == true ? .linear(duration: 0.75) : nil)
            .onAppear(){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    animation = true
                }
            }
           
    }
    
    var content:some View{
        HStack{
            
            ForEach(tabs){item in
                TabButton(tab:item,selectTab:$selectTab,action: action)
                if item.id != tabs.last?.id {
                    Spacer()
                }
            }
        

        }
        .padding(.horizontal,25)
        .padding(.vertical,8)
        .background(Color.white)
        .clipShape(Capsule())
        .shadow(color: Color("shadow"), radius: 5, x: 5, y: 5)
        .shadow(color: Color("shadow"), radius: 5, x: -5, y: -5)
        .padding(.horizontal)
        
        
    }
    
}

struct TabButton:View{
    @State var tab:Segmented
    @Binding var selectTab:Segmented?
    @State var action: (_ tab:Segmented?) -> Void
    var body:some View{

        Button(action: {
            selectTab = tab
            action(selectTab)
        }, label: {
            Text(tab.title!)
                .foregroundColor(selectTab?.id == tab.id ? Color("AccentColor") : Color.gray)
                .font(.caption)
                .padding(.vertical,6)
                .padding(.horizontal,12)
                .background(selectTab?.id == tab.id ? Color("AccentColor").opacity(0.2) : Color.clear)
                .clipShape(Capsule())
               

             
        })
        .buttonStyle(BorderlessButtonStyle())
        
    }
}

struct SegmentedView_Previews: PreviewProvider {
 
    static var previews: some View {
        let tabs:[Segmented] = [
            Segmented(id: 0, title: "全部", icon: nil),
            Segmented(id: 1, title: "持仓", icon: nil),
            Segmented(id: 2, title: "已卖出", icon: nil)
        ]
        return SegmentedView(tabs: tabs, selectTab: .constant(tabs[0]),action: { (tab) in
            return
        } )
            
            .preferredColorScheme(.light)
        
    }
}


