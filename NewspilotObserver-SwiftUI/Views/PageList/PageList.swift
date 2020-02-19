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
    private var publicationDates:[PublicationDate]
    private var subProduct:SubProduct
    
    
    @State var filter=PageFilter()
    @State var showFilterView = false
    
    @EnvironmentObject var loginHandler:LoginHandler
    @EnvironmentObject var statusQuery:StatusQuery
    @EnvironmentObject var organizationQuery:OrganizationsQuery
    @EnvironmentObject var flagQuery:PageFlagQuery
    @ObservedObject var pageQuery:PageQuery
    @State private var useThumbView = true
    
    
    let newspilot:Newspilot
    
    init(newspilot:Newspilot, subProduct:SubProduct, publicationDates:[PublicationDate]) {
        self.newspilot = newspilot;        
        self.subProduct = subProduct
        self.publicationDates = publicationDates
        self.pageQuery = PageQuery(withNewspilot: self.newspilot, productId: subProduct.productID, subProductId: subProduct.id, publicationDateId: -1)
    }
    
    
    var body: some View {
        let pageModelAdapter = PageModelAdapter(newspilotServer:loginHandler.newspilot.server!,
                                                statuses: self.statusQuery.statuses,
                                                sections: self.organizationQuery.sections,
                                                flags: self.flagQuery.flags)
        
        let backs = self.pageQuery.backs
        let backKeys = backs.map{$0.key}.sorted()
        
        let publicationDateString = publicationDates.first(where: {pubDate in pubDate.id == filter.publicationDateId})?.name ?? "PubDate"
        
        return
            GeometryReader {geometry in
                VStack {
                    if self.useThumbView {
                        ThumbView(pageModelAdapter:pageModelAdapter, backs:backs, backKeys:backKeys, columns: self.getColumns(width:geometry.size.width))
                    }else{
                        ListView(pageModelAdapter: pageModelAdapter, backs:backs, backKeys: backKeys)
                    }
                    PageFormatInfoFooter(backs:backs, statusArray: self.statusQuery.statuses).frame(width: geometry.size.width, height: 40, alignment: .center)
                }
                .navigationBarTitle(self.subProduct.name)
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
                                PageFilterView(subProduct:self.subProduct, publicationDates: self.publicationDates, filter: self.$filter)
                        }
                    }
                )
                
            }
                
            .onReceive(self.filter.objectWillChange, perform: {self.reload()})
            .connectionBanner()
        
    }
    
    func getColumns(width:CGFloat) -> Int {
        return Int(width/200)
    }
    
    func reload() {
        if self.pageQuery.publicationDateId != self.filter.publicationDateId {
            self.pageQuery.publicationDateId = self.filter.publicationDateId
        }
    }
}

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
                            
                            //                            NavigationLink(destination: PageDetailsView(self.getViewsFrom(pageModelAdapter: self.pageModelAdapter, backs: self.backs, backKey: backKey), currentPage: index)) {
                            
                            //                            NavigationLink(destination: PageDetailsView(self.getViewsFrom(pageModelAdapter: self.pageModelAdapter, backs: self.backs, backKey: backKey), currentPage: (row*self.columns)+col)){
                            PageCollectionCell(page:self.pageModelAdapter.getPageViewModel(from: self.backs[backKey]![(row*self.columns)+col])).padding(10)
                            
                        }.padding(.vertical, 20).background(Color.white).cornerRadius(20) //.animation(.spring())
                        
                    }
                }
            }
        }//.background(Color.gray)
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
        }.padding(.top,10).onTapGesture {
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

struct ListView:View
{
    let pageModelAdapter:PageModelAdapter
    let backs:[BackKey:[Page]]
    let backKeys:[BackKey]
    
    var body :some View {
        List {
            ForEach (backKeys, id: \.hashValue) {backKey in
                Section(header:Text("Part: \(backKey.part ?? "-") Edition: \(backKey.edition ?? "-") Version:\(backKey.version ?? "-")")){
                    ForEach (0 ..< self.backs[backKey]!.count, id:\.self) {index in
                        NavigationLink(destination: PageDetailsView(self.getViewsFrom(pageModelAdapter: self.pageModelAdapter, backs: self.backs, backKey: backKey), currentPage: index)) {
                            PageListCell(page:self.pageModelAdapter.getPageViewModel(from: self.backs[backKey]![index]))
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
