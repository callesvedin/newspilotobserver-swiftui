//
//  PageList.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-04.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct PageList: View {
    var subProduct:SubProduct
    
    var body: some View {
        Text("Hello \(subProduct.name)!")
    }
}

struct PageList_Previews: PreviewProvider {
    static var previews: some View {
        PageList(subProduct: SubProduct(id: 1, productId: 11, name: "My Sub Product"))
    }
}
