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
    @ObservedObject var pageQuery:PageQuery
    @State var filter=PageFilter()
    //    @State private var showFilter = false
    
    
    @EnvironmentObject var statusQuery:StatusQuery
    @EnvironmentObject var organizationQuery:OrganizationsQuery
    
    private var pageCellAdapter:PageCellAdapter
    
    init(newspilot:Newspilot, subProduct:SubProduct, publicationDates:[PublicationDate]) {
        self.subProduct = subProduct
        self.publicationDates = publicationDates
        self.pageQuery = PageQuery(withNewspilot: newspilot, productId: subProduct.productID, subProductId: subProduct.id, publicationDateId: -1)
        self.pageCellAdapter = PageCellAdapter(newspilotServer:newspilot.server, statuses: [],sections: [])
    }
    
    
    var body: some View {
        let backs = self.pageQuery.backs
        let backKeys = backs.map{$0.key}
        
        return
            VStack {
                List {
                    ForEach (backKeys, id: \.hashValue) {backKey in
                        Section(header:Text("Part: \(backKey.part ?? "-") Edition: \(backKey.edition ?? "-") Version:\(backKey.version ?? "-")")){
                            ForEach (backs[backKey] ?? []) {page in
                                NavigationLink(destination: PageDetailsView(self.getViewsFrom(backs: backs, backKey: backKey), currentPage: 0)) {
                                    PageListCell(page:self.pageCellAdapter.getCellViewModel(from: page))
                                }
                            }
                        }
                    }
                }
                
            }
            .navigationBarItems(trailing:
                    NavigationLink(destination: PageFilterView(subProduct:self.subProduct, publicationDates: self.publicationDates, filter: self.filter))
                    {
                        Text("Filter")
                    }
            )
            .navigationBarTitle(self.subProduct.name)
            .onAppear(){
                self.pageCellAdapter.statuses = self.statusQuery.statuses
                self.pageCellAdapter.sections = self.organizationQuery.sections
            }.onReceive(filter.objectWillChange, perform: {self.reload()})
    }
    
    func getViewsFrom(backs:[BackKey:[Page]], backKey:BackKey) -> [PageDetailView] {
        let pageList = backs[backKey] ?? []
        let views = pageList.map {PageDetailView(page:$0)}
        return views
    }
    
    func reload() {
        self.pageQuery.publicationDateId = self.filter.publicationDateId
    }
}

struct PageList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PageList(newspilot:Newspilot(server: "", login: "", password: ""), subProduct: SubProduct(id: 1, productId: 11, name: "My Sub Product2", settingsString: ""),
                     publicationDates: [
                        PublicationDate(entityType: "PublicationDate", id: 1, issuenumber: "1", name: "Pub 1", productID: 1, pubDate: "2019-10-10"),
                        PublicationDate(entityType: "PublicationDate", id: 1, issuenumber: "2", name: "Pub 2", productID: 1, pubDate: "2019-10-11"),
                        PublicationDate(entityType: "PublicationDate", id: 1, issuenumber: "1", name: "Pub 1", productID: 1, pubDate: "2019-10-12")
            ])
        }
    }
}
