//
//  SubProductList.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-13.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
import Newspilot

struct SubProductList: View {
    @ObservedObject var organizationQuery:OrganizationsQuery
    @ObservedObject var publicationDateQuery:PublicationDateQuery
    let product:Product
    let newspilot:Newspilot
    
    init(product:Product, newspilot:Newspilot, organizationQuery:OrganizationsQuery) {
        self.product = product
        self.newspilot = newspilot
        self.organizationQuery = organizationQuery
        self.publicationDateQuery=PublicationDateQuery(withNewspilot: newspilot, productId: product.id)
    }
    
    var body: some View {
        List {
            ForEach(organizationQuery.getSubProducts(for:product)) {subProduct in
                NavigationLink(destination:
                PageList(newspilot:self.newspilot, subProduct:subProduct, publicationDates:self.publicationDateQuery.sortedPublicationDates)) {
                    Text(subProduct.name) //.font(.caption).foregroundColor(.gray)
                }
                
            }
        }.navigationBarTitle(product.name).onAppear(){
            self.publicationDateQuery.load()
        }
    }
}

//struct SubProductList_Previews: PreviewProvider {
//    static var previews: some View {
//        SubProductList(product:Product(id: 1, name: "Test Product", organizationID: 1))
//    }
//}
