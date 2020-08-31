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
    
    @State var filter=PageFilter()
    @State var showFilterView = false
    
    @ObservedObject var loginHandler = LoginHandler.shared
    @EnvironmentObject var statusQuery:StatusQuery
    @EnvironmentObject var organizationQuery:OrganizationsQuery
    @EnvironmentObject var flagQuery:PageFlagQuery
    
    @ObservedObject var pageQuery:PageQuery
    var publicationDateQuery:PublicationDateQuery
    
    @State private var useThumbView = true
    @State private var expandChart = false
    @State private var searchText = ""
    
    var backs:[BackKey:[Page]] {
        get {
            self.pageQuery.backs.filter{self.filter.match($0.key)}
        }
    }
    
    var statusItems:[StatusItem] {
        get {
            getStatusItems(fromBacks:backs)
        }
    }

    
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
        
        let pieChartModel = PieChartModel(data: statusItems)
//        let publicationDateString = self.filter.publicationDate?.name ?? "PubDate"
        return
            GeometryReader {geometry in
                ZStack {                    
                    VStack {
                        Button(action:{
                            withAnimation {
                                expandChart.toggle()
                            }
                            
                        }) {
                            PieChartView(chartData:pieChartModel).frame(width: 50, height: 50)
                        }
                        
                        if expandChart {
                            ForEach(pieChartModel.arcData) {arc in
                                HStack {
                                    Arc(startAngle: arc.startAngle, endAngle: arc.endAngle, clockwise: true)
                                        .foregroundColor(Color(arc.pieData.color))
                                        .frame(width: 30, height: 30, alignment: .center).padding(0)
                                        
                                    Text("\(Int(arc.pieData.value)) is \(arc.pieData.title)")
                                    Spacer()
                                }.padding(.leading, 5)
                            }
                        }

                        SearchBar(searchText: $searchText)
                        
                        if self.useThumbView {
                            ThumbView(pageModelAdapter:pageModelAdapter, backs:backs, columns: self.getColumns(width:geometry.size.width), filterText:self.searchText)
                        }else{
                            ListView(pageModelAdapter: pageModelAdapter, backs:backs, filterText:self.searchText)
                        }
                    }
                    
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
                                Button(action:{self.showFilterView = true}, label: {Image(systemName:"line.horizontal.3.decrease.circle")})
                                    .popover( // Why is this so large?
                                        isPresented: self.$showFilterView,
                                        arrowEdge: .top
                                    ) {
                                        PageFilterView(subProduct:self.subProduct, pages: self.pageQuery.pages,publicationDateQuery:self.publicationDateQuery, filter: self.$filter)
                                            .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400,maxHeight: .infinity, alignment: .center)
                                    }
                            }
                    )
                    
                }.edgesIgnoringSafeArea(.bottom) //.edgesIgnoringSafeArea(.leading).edgesIgnoringSafeArea(.trailing)
            }
            .connectionBanner()
            .onAppear(){
                self.pageQuery.load()
            }
        
    }
    
    func getColumns(width:CGFloat) -> Int {
        return Int(width/200)
    }
    
    func getStatusItems(fromBacks backs:[BackKey:[Page]]) -> [StatusItem]{
        var statusItems:[StatusItem] = []
        var statusCountDictionary:[Int:Int] = [:]
        
        for pages in backs.values {
            for page in pages {
                if let statusCount = statusCountDictionary[page.status] {
                    statusCountDictionary[page.status] = statusCount + 1
                }else{
                    statusCountDictionary[page.status] = 1
                }
            }
        }
        
        for (key,value) in statusCountDictionary {
            if let status = statusQuery.status(forId: key) {
                statusItems.append(StatusItem(status: status, value:value))
            }
        }
        return statusItems.sorted()
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
