//
//  SettingView.swift
//  apple (macOS)
//
//  Created by admin on 2021/3/26.
//

import SwiftUI

struct SettingView: View {
    
    @State var host = "127.0.0.1"
    @State var port = "8888"
    
    @State var httpPort = "8181"
    @State var dbfile = UserDefaults.standard.string(forKey: "dbfile")
    
 
    var body: some View {
        VStack(alignment: .leading){
            
            socketSetting
            httpSetting
            dbSetting
            test
            
        }
        .padding(.all)
        .frame(width: 400, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .navigationTitle("设置")
        
    }
    
    var socketSetting:some View{
        Group (){
            Text("socket设置")
                .font(.subheadline)
                .fontWeight(.medium)
                .opacity(0.4)
            VStack(alignment: .trailing){
                
                
                
                VStack {
                    HStack(){
                        Text("ip地址")
                        TextField("请输入ip地址", text: $host)
                            .font(.title3)
                            .padding(8)
                            .background(Color("Background 1"))
                            .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .padding(.vertical, 8)
                        
                    }
                    HStack{
                        Text("端口号")
                        TextField("请输入端口号", text: $port)
                            .font(.title3)
                            .padding(8)
                            .background(Color("Background 1"))
                            .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .padding(.vertical, 8)
                    }
                }
                
                
             
                
            }
            
        }
        .padding(.trailing)
    }
    
    var httpSetting:some View{
        Group (){
            Text("http设置")
                .font(.subheadline)
                .fontWeight(.medium)
                .opacity(0.4)
            VStack(alignment: .trailing){
                
                VStack {
                   
                    HStack{
                        Text("端口号")
                        TextField("请输入端口号", text: $httpPort)
                            .font(.title3)
                            .padding(8)
                            .background(Color("Background 1"))
                            .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .padding(.vertical, 8)
                    }
                }
                
               
                
            }
            
        }
        .padding(.trailing)
    }
    
    var dbSetting:some View{
        Group{
            Text("db设置")
                .font(.subheadline)
                .fontWeight(.medium)
                .opacity(0.4)
            
            HStack{
                Text(dbfile ?? "")
                    .font(.subheadline)
                    .padding(8)
                    .background(Color("Background 1"))
                    .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .padding(.vertical, 8)
                
                Button(action: findFile) {
                    Text("选择文件")
                }
                
            }
        }
    }
    
    var test:some View{
        Group{
            Text("测试按钮")
                .font(.subheadline)
                .fontWeight(.medium)
                .opacity(0.4)
            
            HStack{
                
                Button(action: dotest) {
                    Text("测试按钮")
                }
                
            }
        }
    }
    
    func start() {
    
    }
    
    func stop() {
      
    }
    func httpStart(){
       
    }
    
    private func findFile(){
        let openPanel = NSOpenPanel()
        
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = false
//        openPanel.allowedFileTypes = ["db"]
        openPanel.begin { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                let defaults = UserDefaults.standard
                defaults.set(openPanel.url?.absoluteString, forKey: "dbfile")
                dbfile = openPanel.url?.absoluteString
                SQLiteManage.updatefile()
                print(defaults.string(forKey: "dbfile")!)
            }
        }
    }
    
    private func dotest(){
  
//        pythonManageTest1()
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
