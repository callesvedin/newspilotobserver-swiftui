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
    
    var productId:Int
    var product:Product? = nil
    
    init(productId:Int) {
        self.productId = productId        

    }
    var body: some View {
        Text("Hello \(product != nil ? product!.name: "")")
    }
}

struct SubProductList_Previews: PreviewProvider {
    static var previews: some View {
        SubProductList(productId:1)
    }
}
