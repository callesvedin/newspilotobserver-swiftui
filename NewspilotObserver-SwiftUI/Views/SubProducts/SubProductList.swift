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
    @EnvironmentObject var organizationQuery:OrganizationsQuery
    @EnvironmentObject var loginHandler:LoginHandler
    @ObservedObject var publicationDateQuery:PublicationDateQuery
    let product:Product
    
    
    init(product:Product, publicationDateQuery: PublicationDateQuery) {
        self.product = product
        self.publicationDateQuery = publicationDateQuery
    }
    
    var body: some View {
        
        List {
            ForEach(organizationQuery.getSubProducts(for:product)) {subProduct in
                NavigationLink(destination:
                
                    PageList(newspilot:self.loginHandler.newspilot, subProduct:subProduct,
                         publicationDates:self.publicationDateQuery.sortedPublicationDates))
                    {
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
