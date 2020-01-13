//
//  PageList.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-04.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
import Newspilot
import QGrid

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
    @State private var useThumbView = false
    
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
        let columns = 4
        return
            GeometryReader {geometry in
                ZStack {
                    if self.useThumbView {
                        List {
                            ForEach (backKeys, id: \.hashValue) {backKey in
                                Section(header:Text("Part: \(backKey.part ?? "-") Edition: \(backKey.edition ?? "-") Version:\(backKey.version ?? "-")")){
                                    GridStack(rows: Int(Float(backs[backKey]!.count / columns).rounded(.up)), columns: columns){row, col in
                                        PageCollectionCell(page:pageModelAdapter.getPageViewModel(from: backs[backKey]![(row*columns)+col]))
                                    }
                                }
                            }
                        }
                    }else{
                        List {
                            ForEach (backKeys, id: \.hashValue) {backKey in
                                Section(header:Text("Part: \(backKey.part ?? "-") Edition: \(backKey.edition ?? "-") Version:\(backKey.version ?? "-")")){
                                    ForEach (0 ..< backs[backKey]!.count, id:\.self) {index in
                                        NavigationLink(destination: PageDetailsView(self.getViewsFrom(pageModelAdapter: pageModelAdapter, backs: backs, backKey: backKey), currentPage: index)) {
                                            PageListCell(page:pageModelAdapter.getPageViewModel(from: backs[backKey]![index]))
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    if self.showFilterView {
                        BottomSheetView(isOpen: self.$showFilterView,
                                        maxHeight: geometry.size.height * 0.6)
                        {
                            PageFilterView(subProduct:self.subProduct, publicationDates: self.publicationDates, filter: self.$filter, shown:self.$showFilterView)
                        }
                    }
                    
                }
                .onAppear(){
                    self.reload()
                }
                .navigationBarItems(
                    leading:
                    Picker("", selection: self.$useThumbView) {
                        Image(systemName: "list.bullet").tag(false)
                        Image(systemName: "list.bullet.below.rectangle").tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(),
                    trailing:Button(action:{self.showFilterView = true}, label: {Text(publicationDateString)})
                )
                    .navigationBarTitle(self.subProduct.name)
                    //            .sheet(isPresented: $showFilterView) {
                    //                PageFilterView(subProduct:self.subProduct, publicationDates: self.publicationDates, filter: self.$filter)
                    //            }
                    .onReceive(self.filter.objectWillChange, perform: {self.reload()})
                    .connectionBanner()
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
    
    func reload() {
        if self.pageQuery.publicationDateId != self.filter.publicationDateId {            
            self.pageQuery.publicationDateId = self.filter.publicationDateId
        }
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
