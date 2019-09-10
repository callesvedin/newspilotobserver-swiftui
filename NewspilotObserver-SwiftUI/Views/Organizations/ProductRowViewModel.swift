//
//  ProductRowViewModel.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-10.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation

class ProductRowViewModel:Identifiable {
    var name:String
    
    init(name:String) {
        self.name = name
    }
}
