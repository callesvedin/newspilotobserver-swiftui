//
//  OrganizationsView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-06.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct OrganizationList: View {
    @EnvironmentObject var query:OrganizationsQuery
        
    var body: some View {
        NavigationView {
            List {
                if query.organizations.isEmpty {
                    emptySection
                } else {
                    organizationsList
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Organizations")
        }
    }
}

private extension OrganizationList {
    var emptySection: some View {
        Text("No results (yet)")
            .foregroundColor(.gray)
    }
    
    var organizationsList: some View {
        ForEach(query.getOrganizations()) {organization in
            Section(header: Text(organization.name).bold()) {
                ForEach(self.query.getProducts(for: organization)){product in
                    NavigationLink(destination: SubProductList(productId:product.id)) {
                        ProductRow(product:product)
                    }
                }
            }
        }
    }
}

struct OrganizationsView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationList()
    }
}
