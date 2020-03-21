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
    var imageString:String
    var image:UIImage?
    
    init(product:Product) {
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
                Spacer()
            }            
        }
    }
}

struct ProductRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ProductRow(product: Product(id:11,name: "WCN Daily",organizationID: 1)).previewLayout(.fixed(width: 300, height: 50))
            ProductRow(product: Product(id:1,name: "WCN Nightly",organizationID: 1)).previewLayout(.fixed(width: 300, height: 50))
        }
    }
}
