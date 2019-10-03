//
//  SubProductList.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-13.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct SubProductList: View {
    @ObservedObject var query:OrganizationsQuery
    
    var product:Product
    
    init(product:Product, query:OrganizationsQuery) {
        self.product = product
        self.query = query
    }
    
    var body: some View {
        List {
            ForEach(query.getSubProducts(for:product)) {subProduct in
                Text(subProduct.name) //.font(.caption).foregroundColor(.gray)
            }
        }.navigationBarTitle(product.name)           
    }
}

//struct SubProductList_Previews: PreviewProvider {
//    static var previews: some View {
//        SubProductList(product:Product(id: 1, name: "Test Product", organizationID: 1))
//    }
//}
