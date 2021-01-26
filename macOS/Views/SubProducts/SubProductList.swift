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
    
    @StateObject var selectionModel:SelectionModel
    
    var body: some View {        
        List(selection: $selectionModel.subproduct) {
            ForEach(organizationQuery.getSubProducts(for:selectionModel.product!)) {subProduct in
                Text(subProduct.name).font(Font.bodyFont).tag(subProduct)
            }
        }
        .connectionBanner()
//        .navigationBarTitle(product.name)        
    }
}

struct SubProductList_Previews: PreviewProvider {
    static var previews: some View {
        let product = Product(id: 1, name: "Test Product", organizationID: 1)
        let selectionModel = SelectionModel()
        selectionModel.product = product
        return SubProductList(selectionModel: selectionModel)
            .environmentObject(OrganizationsQuery(withStaticOrganizations: organizationData, products: productsData, subProducts: subProductsData, andSections: sectionsData))            
    }
}
