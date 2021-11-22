//
//  PageList.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-04.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
import Newspilot


class StatusItem:PieChartData, Identifiable, Comparable {
    static func < (lhs: StatusItem, rhs: StatusItem) -> Bool {
        lhs.status.sortKey < rhs.status.sortKey
    }
    
    static func == (lhs: StatusItem, rhs: StatusItem) -> Bool {
        lhs.status.id == rhs.status.id
    }
    
    public let id:UUID = UUID.init()
    let status:Status
    var value:Double
    var title:String {
        get {
            status.name
        }
    }
    var color:UIColor {
        get{
            UIColor.intToColor(value: Int(status.color))
        }
    }
    
    init(status:Status, value:Int) {
        self.status = status
        self.value = Double(value)
    }
    
}


struct PageList: View {
    private var subProduct:SubProduct
    
    @StateObject var filter=PageFilter()
    @State var showFilterView = false
    
    @ObservedObject var loginHandler = LoginHandler.shared
    @EnvironmentObject var statusQuery:StatusQuery
    @EnvironmentObject var organizationQuery:OrganizationsQuery
    @EnvironmentObject var flagQuery:PageFlagQuery
    
    @ObservedObject var pageQuery:PageQuery
    var publicationDateQuery:PublicationDateQuery
    
    @State private var useThumbView = false
    //@State private var expandChart = false
    @State private var searchText = ""
    @State var pageAction = PageAction()
    @State var showStatusChange = false
    @State var expandedBacks = Set<BackKey>()
    
    var backs:[BackKey:[Page]] {
        get {
            self.pageQuery.backs.filter{self.filter.match($0.key)}
        }
    }
    
    //    var statusItems:[StatusItem] {
    //        get {
    //            getStatusItems(fromBacks:backs)
    //        }
    //    }
    
    
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
        //        let pieChartModel = PieChartModel(data: statusItems)
//        let publicationDateString = self.filter.publicationDate?.name ?? "PubDate"
        return

            VStack {
                if self.useThumbView {
                    ThumbView(pageModelAdapter:pageModelAdapter, backs:backs, expandedBacks: self.$expandedBacks, filterText:self.searchText, pageAction: self.pageAction, showAction:self.$showStatusChange)
                }else{
                    ListView(pageModelAdapter: pageModelAdapter, backs:backs, expandedBacks: self.$expandedBacks, filterText:self.searchText, pageAction: self.pageAction, showAction:self.$showStatusChange)
                }
            }                        
            .toolbar {
                ToolbarItem (placement: .automatic) {
                    SearchBar(searchText: $searchText).frame(width: 400).padding(.trailing, 20)
                }

                ToolbarItem (placement: .automatic) {
                    Picker("", selection: self.$useThumbView) {
                        Image(systemName: "list.bullet").resizable().tag(false)
                        Image(systemName: "list.bullet.below.rectangle").resizable().tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.trailing, 20)
                }

                ToolbarItem (placement: .automatic) {
                    Button(action:{self.showFilterView = true}, label: {Image(systemName:"line.horizontal.3.decrease.circle")})
                        .popover( // Why is this so large?
                            isPresented: self.$showFilterView,
                            arrowEdge: .top
                        ) {
                            PageFilterView(subProduct:self.subProduct, pages: self.pageQuery.pages,publicationDateQuery:self.publicationDateQuery, filter: self.filter)
                                .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400,maxHeight: .infinity, alignment: .center)
                        }.buttonStyle(PlainButtonStyle())
                }

            }            
            .connectionBanner()
            .onAppear(){
                self.pageQuery.load()
            }
            .sheet(isPresented: self.$showStatusChange, content: {
                if (pageAction.type == .ChangeStatus) {
                    SetStatusView(page:pageAction.page!, statuses:statusQuery.statusesBySortkey(),isShown: self.$showStatusChange)                    
                }
            })
    }
    
    func getColumns(width:CGFloat) -> Int {
        return Int(width/200)
    }
    
    //    func getStatusItems(fromBacks backs:[BackKey:[Page]]) -> [StatusItem]{
    //        var statusItems:[StatusItem] = []
    //        var statusCountDictionary:[Int:Int] = [:]
    //
    //        for pages in backs.values {
    //            for page in pages {
    //                if let statusCount = statusCountDictionary[page.status] {
    //                    statusCountDictionary[page.status] = statusCount + 1
    //                }else{
    //                    statusCountDictionary[page.status] = 1
    //                }
    //            }
    //        }
    //
    //        for (key,value) in statusCountDictionary {
    //            if let status = statusQuery.status(forId: key) {
    //                statusItems.append(StatusItem(status: status, value:value))
    //            }
    //        }
    //        return statusItems.sorted()
    //    }
}


struct PageList_Previews: PreviewProvider {
    static var previews: some View {
        let loginHandler=LoginHandler.shared
        return NavigationView {
            PageList(newspilot:loginHandler.newspilot,
                     subProduct: SubProduct(id: 1, productId: 11, name: "My Sub Product2", settingsString: ""),
                     pageQuery: PageQuery(withNewspilot: loginHandler.newspilot, productId: 1, subProductId: 1, publicationDateId: 1)
            )
        }
    }
}
