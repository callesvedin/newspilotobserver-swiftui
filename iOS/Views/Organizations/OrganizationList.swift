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
    @EnvironmentObject var organizationQuery:OrganizationsQuery
    @ObservedObject var loginHandler = LoginHandler.shared
    
    @State var connectionLost:Bool = false

    var body: some View {
        List {
            organizationsList
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Organizations")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {loginHandler.logout()}, label: {
            HStack {
                Image(systemName: "lock")
                Text("Logout").font(Font.buttonFont)
            }
        }))
        .font(Font.bodyFont)

        .connectionBanner()
    }
}

private extension OrganizationList {    
    var organizationsList: some View {
        ForEach(organizationQuery.organizations) {organization in
            Section(header: Text(organization.name).bold()) {
                ForEach(self.organizationQuery.getProducts(for: organization)){product in
                    Link(product:product) {
                        ProductRow(product:product)
                    }
                }
            }
        }
    }
}

struct OrganizationList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                OrganizationList().environmentObject(OrganizationsQuery(withStaticOrganizations: organizationData, products: productsData, subProducts: subProductsData, andSections: sectionsData))
            }.environment(\.colorScheme, .dark)
            
            NavigationView {
                OrganizationList().environmentObject(OrganizationsQuery(withStaticOrganizations: organizationData, products: productsData, subProducts: subProductsData, andSections: sectionsData))
            }
            
        }
    }
}

struct Link<Content: View>: View {
    let product:Product
    let content: Content
    
    init(product:Product, @ViewBuilder content: () -> Content) {
        self.product = product
        self.content = content()
    }

    var body: some View {
        NavigationLink(destination: SubProductList(product:product)) {
            content
        }.isDetailLink(false)
    }
    
}