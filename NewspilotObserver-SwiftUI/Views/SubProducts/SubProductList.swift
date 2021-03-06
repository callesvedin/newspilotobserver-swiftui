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
    @ObservedObject var loginHandler = LoginHandler.shared
    
    let product:Product
    
    
    init(product:Product) {
        self.product = product
    }
    
    var body: some View {        
        List {
            ForEach(organizationQuery.getSubProducts(for:product)) {subProduct in
                NavigationLink(
                    destination: PageList(newspilot:self.loginHandler.newspilot,
                                          subProduct:subProduct,
                                          pageQuery: PageQueryManager.shared.getPageQuery(
                                            withProductId: subProduct.productID,
                                            subProductId:subProduct.id)
                    )
                )
                {
                    Text(subProduct.name) //.font(.caption).foregroundColor(.gray)
                }                
            }
        }
        .connectionBanner()
        .navigationBarTitle(product.name)        
    }
}

struct SubProductList_Previews: PreviewProvider {
    static var previews: some View {
        return SubProductList(
            product:Product(id: 1, name: "Test Product", organizationID: 1))
            .environmentObject(OrganizationsQuery(withStaticOrganizations: organizationData, products: productsData, subProducts: subProductsData, andSections: sectionsData))            
    }
}
