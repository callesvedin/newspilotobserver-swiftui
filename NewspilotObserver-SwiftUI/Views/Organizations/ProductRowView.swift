//
//  ProductRowView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-10.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct ProductRowView: View {
    var product:ProductRowViewModel
    
    init(product:ProductRowViewModel) {
        self.product = product
    }
    var body: some View {
        Text(product.name).font(.caption).foregroundColor(.gray)
    }
}

struct ProductRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProductRowView(product: ProductRowViewModel(name: "Product"))
    }
}
