//
//  ListView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2020-08-08.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI


struct ListView:View
{
    let pageModelAdapter:PageModelAdapter
    let backs:[BackKey:[Page]]
    
    var backKeys:[BackKey] {
        get {
            backs.map{$0.key}.sorted()
        }
    }
    
    @State private var expandedBacks:Set<BackKey> = Set<BackKey>()    
    
    init(pageModelAdapter:PageModelAdapter, backs:[BackKey:[Page]], filterText:String) {
        self.pageModelAdapter = pageModelAdapter
        var filteredBacks:[BackKey:[Page]] = [:]
        backs.keys.forEach({key in
            filteredBacks[key]=backs[key]!.filter({page in filterText.count == 0 || page.name.contains(filterText)})
        })
        self.backs = filteredBacks
    }
    
    var body :some View {
        List {
            ForEach (backKeys, id: \.hashValue) {backKey in
                Section(
                    header:                        
                        SectionHeaderView(backKey: backKey, expanded: self.expandedBacks.contains(backKey))
                            .onTapGesture {
                                
                                if (self.expandedBacks.contains(backKey)){
                                    _ = withAnimation {
                                        self.expandedBacks.remove(backKey)
                                    }
                                }else{
                                    _ = withAnimation {
                                        self.expandedBacks.insert(backKey)
                                    }
                                }
                            }
                )
                {
                    if (self.expandedBacks.contains(backKey)){
                        ForEach (0 ..< self.backs[backKey]!.count, id:\.self) {index in
                                NavigationLink(destination: PageDetailsView(self.getViewsFrom(pageModelAdapter: self.pageModelAdapter, backs: self.backs, backKey: backKey), currentPage: index)) {
                                    PageListCell(page:self.pageModelAdapter.getPageViewModel(from: self.backs[backKey]![index]))
                                }
                        }
                    }
                }
            }
        }
        .onAppear {
            self.backs.keys.forEach {expandedBacks.insert($0)}
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


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        var pages:[Page] = []
        pages.append(contentsOf: pageData)
        pages.append(contentsOf: pageData2)
        pages.append(contentsOf: pageData3)
        
        let pageBacks = PageQuery.createBacks(pages: pages)
        let pageModelAdapter = PageModelAdapter(newspilotServer: "server", statuses: statusData, sections:sectionsData, flags: [])
        return
            Group{
                ListView(pageModelAdapter: pageModelAdapter, backs: pageBacks, filterText: "")
//                    .previewLayout(PreviewLayout.sizeThatFits)
                                    .padding()
                                    .previewDisplayName("Default preview 1")

                ListView(pageModelAdapter: pageModelAdapter, backs: pageBacks, filterText: "")
//                                    .previewLayout(PreviewLayout.sizeThatFits)
                                    .padding()
//                                    .background(Color(.systemBackground))
                                    .environment(\.colorScheme, .dark)
                                    .previewDisplayName("Dark Mode")
            }
    }
}
