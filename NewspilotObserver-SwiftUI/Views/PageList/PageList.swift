//
//  PageList.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-04.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
import Newspilot

struct PageList: View {
    private var subProduct:SubProduct
    
    @State var filter=PageFilter()
    @State var showFilterView = false
    
    @EnvironmentObject var statusQuery:StatusQuery
    @EnvironmentObject var organizationQuery:OrganizationsQuery
    @EnvironmentObject var flagQuery:PageFlagQuery
    
    @ObservedObject var pageQuery:PageQuery
    var publicationDateQuery:PublicationDateQuery
    
    @State private var useThumbView = true
    
    let newspilot:Newspilot
    
    init(newspilot:Newspilot, subProduct:SubProduct, pageQuery:PageQuery) {
        self.newspilot = newspilot
        self.subProduct = subProduct
        self.pageQuery = pageQuery
        self.publicationDateQuery = PublicationDateQueryManager.shared.getPublicationDateQuery(withProductId: subProduct.productID)
    }
    
    
    var body: some View {
        let pageModelAdapter = PageModelAdapter(newspilotServer:self.newspilot.server!,
                                                statuses: self.statusQuery.statuses,
                                                sections: self.organizationQuery.sections,
                                                flags: self.flagQuery.flags)
        let backs = self.pageQuery.backs
        let backKeys = backs.map{$0.key}.filter{self.filter.match($0)}.sorted()
        
        let publicationDateString = self.filter.publicationDate?.name ?? "PubDate"
        return
            GeometryReader {geometry in
                ZStack {
                    Color.white
                    VStack {
                        if self.useThumbView {
                            ThumbView(pageModelAdapter:pageModelAdapter, backs:backs, backKeys:backKeys, columns: self.getColumns(width:geometry.size.width))
                        }else{
                            ListView(pageModelAdapter: pageModelAdapter, backs:backs, backKeys: backKeys)
                        }
                        PageFormatInfoFooter(backs:backs, filter:self.filter, statusArray: self.statusQuery.statuses).frame(width: geometry.size.width, height: 40, alignment: .center)
                    }.background(Color.white)
                    
                    .navigationBarTitle(Text(self.subProduct.name), displayMode: NavigationBarItem.TitleDisplayMode.inline )
                    .navigationBarItems(
                        trailing:
                            HStack {
                                Picker("", selection: self.$useThumbView) {
                                    Image(systemName: "list.bullet").tag(false)
                                    Image(systemName: "list.bullet.below.rectangle").tag(true)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding()
                                Button(action:{self.showFilterView = true}, label: {Text(publicationDateString)})
                                    .popover( // Why is this so large?
                                        isPresented: self.$showFilterView,
                                        arrowEdge: .top
                                    ) {
                                        PageFilterView(subProduct:self.subProduct, pages: self.pageQuery.pages,publicationDateQuery:self.publicationDateQuery, filter: self.$filter)
                                    }
                            }
                    )
                    
                }.edgesIgnoringSafeArea(.all)
            }
            .connectionBanner()
            .onAppear(){
                self.pageQuery.load()
            }
        
    }
    
    func getColumns(width:CGFloat) -> Int {
        return Int(width/200)
    }
    
}

struct ListView:View
{
    let pageModelAdapter:PageModelAdapter
    let backs:[BackKey:[Page]]
    let backKeys:[BackKey]
    @State private var expandedBacks:Set<BackKey> = Set<BackKey>()
    
    var body :some View {
        List {
            ForEach (backKeys, id: \.hashValue) {backKey in
                Section(
                    header:
                        SectionHeaderView(backKey: backKey, expandedBacks: self.$expandedBacks)
                        .padding()
                        .background(Color.white)
                        .listRowInsets(EdgeInsets(
                            top: 0,
                            leading: 0,
                            bottom: 0,
                            trailing: 0))
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

//struct PageList_Previews: PreviewProvider {
//    static var previews: some View {
//        let loginHandler=LoginHandler()
//        return NavigationView {
//            PageList(newspilot:loginHandler.newspilot, subProduct: SubProduct(id: 1, productId: 11, name: "My Sub Product2", settingsString: ""),
//                     publicationDates: [
//                        PublicationDate(entityType: "PublicationDate", id: 1, issuenumber: "1", name: "Pub 1", productID: 1, pubDate: "2019-10-10"),
//                        PublicationDate(entityType: "PublicationDate", id: 1, issuenumber: "2", name: "Pub 2", productID: 1, pubDate: "2019-10-11"),
//                        PublicationDate(entityType: "PublicationDate", id: 1, issuenumber: "1", name: "Pub 1", productID: 1, pubDate: "2019-10-12")
//            ]).environmentObject(LoginHandler())
//        }
//    }
//}
