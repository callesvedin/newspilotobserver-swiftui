//
//  ThumbView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2020-03-21.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import SwiftUI

struct ThumbView:View
{
    let pageModelAdapter:PageModelAdapter
    let backs:[BackKey:[Page]]
    let backKeys:[BackKey]
    let columns:Int
    @State private var expandedBacks:Set<BackKey> = Set<BackKey>()
    
    var body: some View {
        List {
            ForEach (self.backKeys, id: \.hashValue) {backKey in
                Section(header:SectionHeader(backKey: backKey, expandedBacks:self.$expandedBacks)) {
                    if (self.expandedBacks.contains(backKey)){
                        GridStack(rows: Int(Float(self.backs[backKey]!.count / self.columns).rounded(.up)), columns: self.columns){row, col in
                            PageCollectionCell(page:self.pageModelAdapter.getPageViewModel(from: self.backs[backKey]![(row*self.columns)+col])).padding(20).shadow(  radius: 5)
                            
                        }.padding(.vertical, 20).background(Color.white).cornerRadius(20) //.animation(.spring())
                        
                    }
                }
            }
        }//.background(Color.gray)
    }
    
    
}


struct ThumbView_Previews: PreviewProvider {
    static var previews: some View {
        let pages = pageData
        
        let pageBacks = PageQuery.createBacks(pages: pages)
        let pageModelAdapter = PageModelAdapter(newspilotServer: "server", statuses: statusData, sections:sectionsData, flags: [])
        let backs = pageBacks.keys.map({$0})
        return ThumbView(pageModelAdapter: pageModelAdapter , backs: pageBacks, backKeys: backs, columns: 3)
        
    }
}

