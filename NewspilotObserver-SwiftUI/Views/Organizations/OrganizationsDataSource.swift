//
//  OrganizationsDataSource.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-16.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
class OrganizationsDataSource: ObservableObject, Identifiable {
  

    func getOrganizations() -> [Organization] {return []}
    
    func getProducts(for:Organization) -> [Product] {return []}
    
    
}
