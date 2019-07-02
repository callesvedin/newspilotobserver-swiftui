//
//  ProductListView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-06-29.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct ProductListView : View {
    
    @EnvironmentObject var productStore: ProductStore
    @EnvironmentObject var organizationStore: OrganizationStore
    
    var body: some View {
        List {
            ForEach(organizationStore.allOrganizations.identified(by: \.objectID)) {org in
                Section(header: Text("\(org.name ?? "")")) {
                    ForEach(self.productStore.productsFor(organizationId: org.entityId).identified(by: \.objectID)) {prod in
                        HStack {
                            Image(uiImage: self.getImage(prod))
                            Text("\(prod.name!)")
                        }
                    }
                }
            }
        }
    }
    
    func getImage(_ product:ProductEntity) -> UIImage {
        let productImage = UIImage(named: "Product_\(Int(product.entityId))")
        if productImage != nil {
            let newImage = ProductImageFactory.shared.resize(image: productImage!, to: CGSize(width:50, height:50))
            if newImage != nil {
                return newImage!
            }
        }
        return ProductImageFactory.shared.getProductImage(fromProductName: product.name ?? "")!
    }
}

#if DEBUG
struct ProductListView_Previews : PreviewProvider {
    static var previews: some View {
        ProductListView().environmentObject(ProductStore()).environmentObject(OrganizationStore())
    }
}
#endif
