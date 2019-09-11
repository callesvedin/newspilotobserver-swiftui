//
//  OrganizationsView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-06.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct OrganizationList: View {
    @ObservedObject var viewModel:OrganizationsViewModel
    
    init(viewModel:OrganizationsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List {
            if viewModel.dataSource.isEmpty {
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
        ForEach(viewModel.dataSource) {organization in
            Section(header: Text(organization.name).bold()) {
                ForEach(organization.products){product in
                    NavigationLink(destination: OrganizationList(viewModel: self.viewModel)) {
                        ProductRow(product:product)
                    }
                }
            }
        }
    }
}

struct OrganizationsView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationList(viewModel:
            OrganizationsViewModel(organizationRows: [
                OrganizationRowViewModel(id: 1, name: "West Coast News", products: [
                        ProductRowViewModel(id: 1, name: "Product 1"),
                        ProductRowViewModel(id: 2, name: "Product 2")
                ]),
                OrganizationRowViewModel(id: 2, name: "East Coast News", products: [
                        ProductRowViewModel(id: 3, name: "Product 3"),
                        ProductRowViewModel(id: 4, name: "Product 4")
                ])

            ])
            
            )
    }
}
