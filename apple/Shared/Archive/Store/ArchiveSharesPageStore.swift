//
//  ArchiveSharesPageStore.swift
//  Share
//
//  Created by admin on 2020/12/16.
//  Copyright © 2020 MBA. All rights reserved.
//

import SwiftUI


class ArchiveSharesPageStore: ObservableObject {
    
    @Published var shares:[Share] = []
    @Published var loading = false
    
    /**
     获取列表
     */
   func update() {

    let issql = UserDefaults.standard.bool(forKey: "isSql")
    if issql {
        Share.db_shares { (error, results) in
            
            self.loading = false
            if((error) != nil){
                print(error?.description as Any)
            }else{
                self.shares = results ?? [Share]()
            }
        }
    }else{
        Share.api_shares  { (error, results) in
            
            self.loading = false
            if((error) != nil){
                print(error?.description as Any)
            }else{
                self.shares = results ?? [Share]()
            }
        }
    }
   }


}
