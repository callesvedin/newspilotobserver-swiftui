//
//  OrganizationsViewModel.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-06.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

class OrganizationsViewModel: ObservableObject, Identifiable {
    
    @Published var dataSource: [OrganizationRowViewModel] = []
        
    init(query:OrganizationsQuery) {
        
    }
    
}

