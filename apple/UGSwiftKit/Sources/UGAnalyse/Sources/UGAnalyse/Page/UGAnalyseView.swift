//
//  SwiftUIView.swift
//  
//
//  Created by admin on 2021/4/29.
//

import SwiftUI
import PythonKit

public struct UGAnalyseView: View {
 
    @ObservedObject var store:UGAnalyse
    @State var isShowForm = true
    @State var isshowShareList = false
    @StateObject var klineStore = SWWebViewStore() // K线
    @StateObject var pieStore = SWWebViewStore() // 收益pie
    @StateObject var lineStore = SWWebViewStore() // 收益曲线
    
    public init(store:UGAnalyse) {
        self.store = store
        self.store.plot.name = "damrey"
        self.store.code = "000001.SZ"
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
            
            Form{
                Image(systemName:"arrow.backward.circle")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.all, 4)
                    .background(Color.black.opacity(0.1))
                    .mask(Circle())
                    .offset(x: isShowForm ? 0 : -100)
                    .onTapGesture(perform: {
                        withAnimation(){
                            isShowForm.toggle()
                        }
                        
                    })
                Section{
                    Text("基础") 
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    baseView
                }
                Section{
                    Text("方案入参")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    ForEach(0..<store.plot.params.count, id: \.self) {
                        ParamView(item: $store.plot.params[$0])
                    }
                }
                
                Button(action: {
                   try? store.plotparam()
                }, label: {
                    Text("Button")
                })
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
        .onAppear(){
            setup()
        }
    }
    
    //
    var baseView:some View{

        Group{
            TextField("LocalizedStringKey", text: $store.code)
                .overlay(
                    Image(systemName: "filemenu.and.selection")
                        .onTapGesture {
                            isshowShareList.toggle()
                        }
                        .sheet(isPresented: $isshowShareList, content: {
                            SheetWithCloseView {
                                ShareListView(name: $store.code)
                            }
                            .frame(minWidth: 300, idealWidth: 300, maxWidth: .infinity)
                            .padding(EdgeInsets.init(top: 10, leading: 20, bottom: 30, trailing: 40))
                        
                        }),
                    alignment: .trailing
                )
            
            DatePicker(
                   "开始",
                   selection: $store.begin,
                   displayedComponents: [.date]
            )
 
            DatePicker(
                   "结束",
                   selection: $store.end,
                   displayedComponents: [.date]
               )
            TextField("方案", text: $store.plot.name) { isbegin in
                print(isbegin)
                if isbegin == false {
                    do{
                        try self.store.plotInfo()
                    }catch{
                        print("\(error)")
                    }
                }else{
                    print("begin")
                }
            }
            
        }
        
    }
    
    // plot view
    public var plotView:some View{
        TextField("LocalizedStringKey", text: $store.code)
    }
    
  
    
    
}

struct ParamView: View {
    @Binding var item:Plot.Param
    var body :some View{
        TextField(item.des, text: $item.value)
    }
}
struct UGAnalyseBodyView: View  {
    var body :some View{
        Text("body")
    }
}

extension UGAnalyseView{
    func setup() {
        
        DispatchQueue(label: "python").async {
            let py_sys = Python.import("sys")
            print("Python Version: \(py_sys.version)")
            py_sys.path.append("/Users/admin/Documents/github/UGFAFAFA/code/")
            let anglyse = Python.import("Analyse.\(store.plot.name)")
            let df = anglyse.catchdata("000001.SZ")
            DispatchQueue.main.async {
                reloadklineStore(df:df)
                reloadpieStore(df: df)
                reloadlineStore(df: df)
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
        let pie = Python.import("chart.pie")
        let piedata = df[df["earnings"].notnull() == true]
        let earnings = (piedata["smoney"]*10/piedata["bmoney"]).astype("int").value_counts(
            normalize:true, ascending:true)
        let piepath = pie.pie(earnings,name:"交易收益率",height:"250px").render("/Users/admin/Documents/github/UGFAFAFA/data/tem/pie.html")
        let pieurl = URL(fileURLWithPath: "\(piepath)")
        pieStore.webView.loadFileURL(pieurl, allowingReadAccessTo: pieurl)
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
        lineStore.webView.loadFileURL(pieurl, allowingReadAccessTo: pieurl)
    }
}

struct MAResultView_Previews: PreviewProvider {
    static var previews: some View {
        
        UGAnalyseView(store: UGAnalyse())
            .background(Color.black)
    }
}
