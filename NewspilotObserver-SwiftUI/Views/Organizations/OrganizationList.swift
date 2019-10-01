//
//  OrganizationsView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-06.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
import Newspilot
import Combine

struct OrganizationList: View {
    @EnvironmentObject var query:OrganizationsQuery
        
    var body: some View {
            List {
                if query.organizations.isEmpty {
                    emptySection
                } else {
                    organizationsList
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Organizations").navigationBarBackButtonHidden(true)
    }
}

private extension OrganizationList {
    var emptySection: some View {
        Text("")
            .foregroundColor(.gray)
    }
    
    var organizationsList: some View {
        ForEach(query.getOrganizations()) {organization in
            Section(header: Text(organization.name).bold()) {
                ForEach(self.query.getProducts(for: organization)){product in
                    NavigationLink(destination: SubProductList(product:product, query:self.query)) {
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
