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
    @ObservedObject var organizationQuery:OrganizationsQuery    
    private let statusQuery:StatusQuery
    private var newspilot:Newspilot
    
    init(newspilot:Newspilot) {
        self.newspilot = newspilot
        organizationQuery = OrganizationsQuery(withNewspilot: newspilot)
        statusQuery = StatusQuery(withNewspilot: newspilot)
        statusQuery.load()
    }
    
    var body: some View {
        List {
            if organizationQuery.organizations.isEmpty {
                emptySection
            } else {
                organizationsList
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Organizations")
        .navigationBarBackButtonHidden(true)
        .onAppear(){
            self.organizationQuery.load()
        }
        .environmentObject(self.statusQuery)
        .environmentObject(self.organizationQuery)

    }
}

private extension OrganizationList {
    var emptySection: some View {
        Text("")
            .foregroundColor(.gray)
    }
    
    var organizationsList: some View {
        ForEach(organizationQuery.getOrganizations()) {organization in
            Section(header: Text(organization.name).bold()) {
                ForEach(self.organizationQuery.getProducts(for: organization)){product in
                    NavigationLink(destination: SubProductList(product:product, newspilot: self.newspilot, organizationQuery:self.organizationQuery)) {
                                                                ProductRow(product:product)
                    }
                }
            }
        }
    }
}

struct OrganizationsView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationList(newspilot: Newspilot(server: "", login: "", password: ""))
    }
}
