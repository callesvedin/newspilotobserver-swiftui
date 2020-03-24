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
//                            ZStack {
//                                NavigationLink(
//                                    destination: PageDetailsView(
//                                        self.getViewsFrom(pageModelAdapter: self.pageModelAdapter, backs: self.backs, backKey: backKey), currentPage: (row*self.columns)+col)
//                                ){EmptyView()}
                                PageCollectionCell(page:self.pageModelAdapter.getPageViewModel(from: self.backs[backKey]![(row*self.columns)+col])).padding(10)
//                            }
                        }.padding(.vertical, 20).background(Color.white).cornerRadius(20) //.animation(.spring())
                        
                    }
                }
            }
        }//.background(Color.gray)
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


struct SectionHeader:View {
    let backKey:BackKey
    @Binding var expandedBacks:Set<BackKey>
    
    var body : some View {
        HStack {
            Text("Part: \(self.backKey.part ?? "-") Edition: \(self.backKey.edition ?? "-") Version:\(self.backKey.version ?? "-")")
            Spacer()
            Image(systemName: "chevron.right")
                .rotationEffect(.degrees(self.expandedBacks.contains(backKey) ? 90 : 0))
        }.padding(.all,10).onTapGesture {
            if (self.expandedBacks.contains(self.backKey)){
                withAnimation {
                    self.expandedBacks.remove(self.backKey)
                }
            }else{
                withAnimation {
                    self.expandedBacks.insert(self.backKey)
                }
            }
        }
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
        return NavigationView { ThumbView(pageModelAdapter: pageModelAdapter , backs: pageBacks, backKeys: backs, columns: 3)}
        
    }
}

