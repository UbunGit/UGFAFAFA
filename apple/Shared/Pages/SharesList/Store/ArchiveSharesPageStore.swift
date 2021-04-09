//
//  ArchiveSharesPageStore.swift
//  Share
//
//  Created by admin on 2020/12/16.
//  Copyright © 2020 MBA. All rights reserved.
//

import SwiftUI


class ArchiveSharesPageStore: ObservableObject {
    
    @Published var shares:[Share] = [Share].init()
    @Published var searchText:String=""
        {
            didSet {
                if searchText.count > 2 && oldValue.count <= 2 {
                    searchText = oldValue
                }
            }
        }
    @Published var loading = false
    
    /**
     获取列表
     */
   func update() {


        Share.api_shares_list{ (error, results) in

            self.loading = false
            if((error) != nil){
                print(error?.description as Any)
            }else{
                let page = results
                guard let t_shares = page?.datas else {
                    return
                }
                self.shares = t_shares ?? [Share].init()
            }
        }

   }


}
