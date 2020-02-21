//
//  ProductRowView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-10.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct ProductRow: View {
    var product:ProductViewModel
    var imageString:String
    var image:UIImage?
    
    init(product:ProductViewModel) {
        self.product = product
        self.imageString = "Product_\(product.id).png"
        if let filepath = Bundle.main.path(forResource: "Product_\(product.id)", ofType: "png") {
            image = UIImage(contentsOfFile: filepath)
        } else {
            image = ProductImageFactory.shared.getProductImage(fromProductName: product.name)
        }
    }
    var body: some View {
        GeometryReader {geometry in
            HStack {
                if (self.image != nil) {
                    Image(uiImage: self.image!).resizable()
                        .frame(width: geometry.size.height, height: geometry.size.height, alignment: .leading)
                }else{
                    
                }
                
                Text(self.product.name)
            }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
            
        }
    }
}

struct ProductRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ProductRow(product: ProductViewModel(id:11,name: "WCN Daily",organizationID: 1)).previewLayout(.fixed(width: 300, height: 50))
            ProductRow(product: ProductViewModel(id:1,name: "WCN Nightly",organizationID: 1)).previewLayout(.fixed(width: 300, height: 50))
        }
    }
}
