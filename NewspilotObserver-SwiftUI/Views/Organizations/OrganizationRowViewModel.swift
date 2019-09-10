//
//  OrganizationRowViewModel.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-06.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation

class OrganizationRowViewModel:Identifiable {
    let name:String
    let products:[ProductRowViewModel]
    
    init(name:String, products:[ProductRowViewModel]) {
        self.name = name
        self.products = products
    }
}
