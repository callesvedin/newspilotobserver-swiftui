//
//  SubProductList.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-13.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct SubProductList: View {
    @EnvironmentObject var query:OrganizationsQuery
    
    var product:Product
    
    init(product:Product) {
        self.product = product
    }
    
    var body: some View {
        Text("Hello \(product.name)").navigationBarTitle(product.name)
           
    }
}

struct SubProductList_Previews: PreviewProvider {
    static var previews: some View {
        SubProductList(product:Product(id: 1, name: "Test Product", organizationID: 1))
    }
}
