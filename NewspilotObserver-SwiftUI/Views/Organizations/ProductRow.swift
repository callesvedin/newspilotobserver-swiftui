//
//  ProductRowView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-10.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct ProductRow: View {
    var product:Product
    
    init(product:Product) {
        self.product = product
    }
    var body: some View {
        Text(product.name).font(.caption).foregroundColor(.gray)
    }
}

struct ProductRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProductRow(product: Product(id:1,name: "Product",organizationID: 1)).previewLayout(.fixed(width: 300, height: 40))
    }
}
