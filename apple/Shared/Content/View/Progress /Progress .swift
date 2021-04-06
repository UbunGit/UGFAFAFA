//
//  Progress .swift
//  test
//
//  Created by admin on 2020/12/6.
//

import SwiftUI

struct Progress: View {
    @State var animation:Bool = false
    var percent: Float = 0
    var colors = [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))]
    
    var body: some View {
        
        GeometryReader { proxy in
            let mutiplier = proxy.size.width / 44
            let progress = 1 - percent / 100
            
            ZStack{
                
                Circle()
                    .stroke(
                        style: StrokeStyle(lineWidth: 5 * mutiplier)
                    )
                
                
                Circle()
                    .trim(from: CGFloat(progress), to: 1)
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 5 * mutiplier, lineCap: .round, lineJoin: .round)
                    )
                    .rotationEffect(Angle(degrees: 90))
                    .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                    .shadow(color: colors[0].opacity(0.1), radius: 3, x: 0, y: 3)
                
                Text("\(Int(percent))%")
                    .font(.system(size: 14 * mutiplier))
                    .fontWeight(.bold)
                
                
            }
            .animation(animation == true ? .linear(duration: 0.35) : nil)
            .onAppear(){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    animation = true
                }
            }
            
        }
    }
    
    
}

struct Progress__Previews: PreviewProvider {
    static var previews: some View {
        Progress( percent: 10)
    }
}
