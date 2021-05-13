//
//  SwiftUIView.swift
//  
//
//  Created by admin on 2021/4/29.
//

import SwiftUI
import PythonKit
import UGSwiftKit

public struct UGAnalyseView: View {
    
//    @ObservedObject var store:UGAnalyse
    @State var isShowForm = true
    @State var isLoading = false
    @StateObject var paramStore = AnalyseParam()
    @StateObject var klineStore = SWWebViewStore() // K线
    @StateObject var pieStore = SWWebViewStore() // 收益pie
    @StateObject var lineStore = SWWebViewStore() // 收益曲线
    
    public init(store:UGAnalyse) {

      
    }
    public var body: some View {
        HStack(spacing: 4, content: {
            
            ScrollView {
                WebChartView(store: klineStore)
                    .frame( height: 300, alignment: .center)
                
                WebChartView(store: pieStore)
                    .frame( height: 300, alignment: .center)
                
                WebChartView(store: lineStore)
                    .frame( height: 300, alignment: .center)
                
            }
            VStack(alignment: .trailing){
                Image(systemName:"arrow.backward.circle")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.all, 4)
                    .background(Color.black.opacity(0.1))
                    .mask(Circle())
                    .offset(x: isShowForm ? 0 : -300)
                    .onTapGesture(perform: {
                        withAnimation(){
                            isShowForm.toggle()
                        }
                        
                })
                AnalyseParamView(store:paramStore)
                
                HStack{
                    Button("开始分析", action: {
                        analyse()
                    })
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 40, alignment: .center)
                    
                    Button("开始回测", action: {
                        backtrade()
                    })
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 40, alignment: .center)
                    
                }
                Spacer()
            }
            
            .padding()
            .frame(width: 300)
            .datePickerStyle(DefaultDatePickerStyle())
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .background(Color.white
                            .shadow(radius: 10)
            )
            .offset(x: isShowForm ? 0 : 300)
        })
        .loading(isloading: isLoading)
        .onAppear(){
            isLoading = true
            DispatchQueue(label: "python").async {
                let py_sys = Python.import("sys")
                print("Python Version: \(py_sys.version)")
                py_sys.path.append("/Users/admin/Documents/github/UGFAFAFA/code/")
                _ = Python.import("Analyse.back_trading")
                DispatchQueue.main.async {
                    
                    isLoading = false
                }
            }
        }
    }
}


struct UGAnalyseBodyView: View  {
    var body :some View{
        Text("body")
    }
}

extension UGAnalyseView:PyRequest{
    
    func analyse() {
        
//        isLoading = true
        
//        DispatchQueue(label: "python").sync {
            
            var rparam:[String:String] = [:]
            for item in paramStore.analyse.params {
                rparam[item.name] = item.value
            }
            let tdata = try! JSONEncoder().encode(rparam)
            let str = String(data: tdata, encoding: .utf8)!
            let tplot = Python.import("Analyse.\(paramStore.analyse.name)")
            tplot.analyse(code:paramStore.share.code,
                          param:str)
            
//            DispatchQueue.main.async {
//                print("数据分析完成")
//                isLoading = false
//            }
//        }
  
    }
    // 回测
    func backtrade(){
        isLoading = true
        backtrading(analyse: paramStore.analyse.name,
                    code: paramStore.share.code,
                    begin: paramStore.begin.toString("yyyyMMdd"),
                    end: paramStore.end.toString("yyyyMMdd")) { result in
            isLoading = false
            switch result{
            case .success(let pyobj):
                if pyobj.empty == true {
                    print("数据回测数据为空： \(pyobj) ｜🔚")
                    return
                }
                reloadklineStore(df:pyobj)
                reloadpieStore(df: pyobj)
                reloadlineStore(df: pyobj)
            case .failure(let error):
                print("🐜 数据回测错误： \(error)")
            }
        }

    }
  
    
    func reloadklineStore(df:PythonObject)  {
     
        let kline = Python.import("chart.kline")
        let webpath = kline.kline(df,"k线bs图",height:"250px").render("/Users/admin/Documents/github/UGFAFAFA/data/tem/kline.html")
        let url = URL(fileURLWithPath: "\(webpath)")
        klineStore.webView.loadFileURL(url, allowingReadAccessTo: url)
        
        
    }
    
    func reloadpieStore(df:PythonObject)  {
        if Bool(df.empty) == true {return}
        let pie = Python.import("chart.pie")
        let piedata = df[df["earnings"].notnull() == true]
        let earnings = (piedata["smoney"]*10/piedata["bmoney"]).astype("int").value_counts(
            normalize:true, ascending:true)
        let piepath = pie.pie(earnings,name:"交易收益率",height:"250px").render("/Users/admin/Documents/github/UGFAFAFA/data/tem/pie.html")
        let pieurl = URL(fileURLWithPath: "\(piepath)")
        DispatchQueue.main.async {
            pieStore.webView.loadFileURL(pieurl, allowingReadAccessTo: pieurl)
        }
        
    }
    
    func reloadlineStore(df:PythonObject)  {
        let line = Python.import("chart.line")
        let pd = Python.import("pandas")
        let ndf = pd.DataFrame()
        ndf["date"] = df["date"]
        ndf["closev"] = df["close"]/(df["close"].iloc[1])
        ndf["assetsv"] = df["assets"]/10000
        let piepath = line.line(ndf,name:"交易收益率",height:"250px").render("/Users/admin/Documents/github/UGFAFAFA/data/tem/line.html")
        let pieurl = URL(fileURLWithPath: "\(piepath)")
        DispatchQueue.main.async {
            lineStore.webView.loadFileURL(pieurl, allowingReadAccessTo: pieurl)
        }
        
    }
}

struct MAResultView_Previews: PreviewProvider {
    static var previews: some View {
        
        UGAnalyseView(store: UGAnalyse())
            .background(Color.black)
    }
}
