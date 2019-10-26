//
//  PageFilterView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-21.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
enum EditedValue {
    case publicationDate
    case none
}

struct PageFilterView: View {
    let subProduct:SubProduct
    let publicationDates:[PublicationDate]
    let subProductSettings:SubProductSettings?
    let editions:[String]
    @State private var selectedEditionIndex = 0
    
    @ObservedObject var filter:PageFilter
    
    init(subProduct:SubProduct, publicationDates:[PublicationDate], filter:PageFilter) {
        self.subProduct = subProduct
        self.subProductSettings = subProduct.settings
        self.publicationDates = publicationDates
        self.editions = subProduct.settings?.editions ?? []
        self.filter = filter        
    }
    
    var body: some View {
        
        return Form {
            Picker(selection: $filter.publicationDateId, label: Text("Publication")){
                    ForEach(self.publicationDates) { publicationDate in
                        Text("\(publicationDate.name)").tag(publicationDate.id)
                    }
            }//.labelsHidden()
            
//            Picker(selection: $selectedEditionIndex, label: Text("Edition")){
//                ForEach(0 ..< self.editions.count) { index in
//                    Text("\(self.editions[index])").tag(self.editions[index])
//                }
//            }
//
//            Picker(selection: $filter.edition, label: Text("Edition 2")){
//                ForEach(subProduct.settings!.editions, id: \.self) { edition in
//                    Text("\(edition)")
//                }
//            }
            
        }
    }
}

struct PageFilterView_Previews: PreviewProvider {
    static var previews: some View {
        PageFilterView(subProduct: SubProduct(id: 1, productId: 1, name: "Test Sub Product", settingsString: ""),
                       publicationDates: [
                        PublicationDate(entityType: "PublicationDate", id: 1, issuenumber: "", name: "Pub 1", productID: 1, pubDate: "2019-10-20"),
                        PublicationDate(entityType: "PublicationDate", id: 1, issuenumber: "", name: "Pub 1", productID: 1, pubDate: "2019-10-20")],
                       filter: PageFilter())
    }
}
