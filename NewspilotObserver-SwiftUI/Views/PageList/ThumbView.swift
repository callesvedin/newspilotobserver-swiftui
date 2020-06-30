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
    @State var expandedBacks:Set<BackKey> = Set<BackKey>()
    
    var body: some View {
        List {
            ForEach (self.backKeys, id: \.hashValue) {backKey in
                
                Section(header:
                                SectionHeaderView(backKey: backKey, expandedBacks: self.$expandedBacks)
                                    .padding()
                                .background(Color.white)
                                .listRowInsets(EdgeInsets(
                                    top: 0,
                                    leading: 0,
                                    bottom: 0,
                                    trailing: 0)))

                {
                    if (self.expandedBacks.contains(backKey)){
                        GridStack(rows: Int(Float(self.backs[backKey]!.count / self.columns).rounded(.up)), columns: self.columns){row, col in
                            
//                            ZStack {
//                                NavigationLink(
//                                    destination: PageDetailsView(
//                                        self.getViewsFrom(pageModelAdapter: self.pageModelAdapter, backs: self.backs, backKey: backKey), currentPage: (row*self.columns)+col)
//                                ){EmptyView()}
                                PageCollectionCell(page:self.pageModelAdapter.getPageViewModel(from: self.backs[backKey]![(row*self.columns)+col])).padding(10)
//                            }
                        }
                        .background(Color.white)
                        .padding(.vertical, 20)
                        .cornerRadius(20) //.animation(.spring())                        
                    }
                }
            }
        }
    }
    
    func getViewsFrom(pageModelAdapter:PageModelAdapter, backs:[BackKey:[Page]], backKey:BackKey) -> [PageDetailView] {
        let pageList = backs[backKey] ?? []
        let views = pageList.map {page -> PageDetailView in
            let pageViewModel = pageModelAdapter.getPageViewModel(from: page)
            return PageDetailView(page:pageViewModel)
        }
        return views
    }
    
}


struct ThumbView_Previews: PreviewProvider {
    static var previews: some View {
        var pages:[Page] = []
        pages.append(contentsOf: pageData)
        pages.append(contentsOf: pageData2)
        pages.append(contentsOf: pageData3)
        
        let pageBacks = PageQuery.createBacks(pages: pages)
        let pageModelAdapter = PageModelAdapter(newspilotServer: "server", statuses: statusData, sections:sectionsData, flags: [])
        let backs = pageBacks.keys.map({$0})
        return NavigationView {
            ThumbView(pageModelAdapter: pageModelAdapter , backs: pageBacks, backKeys: backs, columns: 3, expandedBacks: Set(arrayLiteral: pageBacks.first!.key))}.previewDevice("iPhone 11").background(Color.white)
        
    }
}

