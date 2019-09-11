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
    private var query:OrganizationsQuery!
    
    private var disposables = Set<AnyCancellable>()
    
    init(organizationRows:[OrganizationRowViewModel]) {
        self.dataSource = organizationRows
    }
    
    init(query:OrganizationsQuery) {
        self.query = query
        _ = query.publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {organizations in
                self.dataSource = self.query.organizations.map({organization in
                        let products = organization.products.map({product in ProductRowViewModel(id:product.id,name:product.name)})
                    return OrganizationRowViewModel(id:organization.id, name:organization.name, products: products)
                    }
                )
            })
            .store(in: &disposables)        
    }
    
}

