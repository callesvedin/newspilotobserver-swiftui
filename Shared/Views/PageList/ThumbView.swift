//
//  ThumbView2.swift
//  NewspilotObserver
//
//  Created by carl-johan.svedin on 2020-10-25.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct ThumbView: View {
    
    let pageModelAdapter:PageModelAdapter
    let backs:[BackKey:[Page]]
    let filterText:String
    
    @ObservedObject private var pageAction:PageAction
    @Binding var statusSelectionViewIsPresented:Bool
    @Binding var expandedBacks:Set<BackKey>
    
    var backKeys:[BackKey] {
        get {backs.map({$0.key}).sorted()}
    }
    
    
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum:150))
    ]
    
    init(pageModelAdapter:PageModelAdapter, backs:[BackKey:[Page]], expandedBacks:Binding<Set<BackKey>>, filterText:String, pageAction:PageAction, showAction:Binding<Bool>) {
        self.pageModelAdapter = pageModelAdapter
        
        self.pageAction = pageAction
        self._statusSelectionViewIsPresented = showAction
        self._expandedBacks = expandedBacks
        self.filterText = filterText
        self.backs = backs
    }
    
    
    var body: some View {
        GeometryReader {geometry in
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach (self.backKeys, id: \.hashValue) {backKey in
                        Section(header:
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
                                    }){
                            if expandedBacks.contains(backKey), let back = backs[backKey] {
                                ForEach(back.filter({self.filterText.isEmpty || $0.name.contains(self.filterText)})){page in
                                    PageCollectionCell(
                                        page:self.pageModelAdapter.getPageViewModel(from: page))
                                        .id(page.id).padding()
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ThumbView2_Previews: PreviewProvider {
    static var previews: some View {
        
        var pages:[Page] = []
        pages.append(contentsOf: pageData)
        pages.append(contentsOf: pageData2)
        pages.append(contentsOf: pageData3)
        
        let pageBacks = PageQuery.createBacks(pages: pages)
        var expandedBacks = Set<BackKey>()
        expandedBacks.insert(pageBacks.first!.key)
        let pageModelAdapter = PageModelAdapter(newspilotServer: "server", statuses: statusData, sections:sectionsData, flags: [])
        
        let devices = ["iPad Pro (12.9-inch) (4th generation)", "iPhone 11"]
        return
            ForEach (devices, id: \.self) {device in
                ThumbView(pageModelAdapter: pageModelAdapter , backs: pageBacks, expandedBacks: .constant(expandedBacks), filterText: "",  pageAction: PageAction(), showAction:Binding.constant(false))
                    .previewDisplayName(device)
                    .previewDevice(PreviewDevice(rawValue:device))
                
                ThumbView(pageModelAdapter: pageModelAdapter , backs: pageBacks, expandedBacks: .constant(expandedBacks), filterText: "", pageAction: PageAction(), showAction:Binding.constant(false))
                    .environment(\.colorScheme, .dark)
                    .previewDisplayName(device)
                    .previewDevice(PreviewDevice(rawValue:device))
            }
        
    }
}
