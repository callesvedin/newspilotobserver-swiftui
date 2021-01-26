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
    
    @StateObject var selectionModel:SelectionModel
    
    var body: some View {
            List (selection: $selectionModel.product) {
                ForEach(organizationQuery.organizations) {organization in
                    Section(header: Text(organization.name).font(Font.title)) {
                        ForEach(self.organizationQuery.getProducts(for: organization)){product in
                            ProductRow(product:product)
                                .tag(product)
                                .font(.title3)
                                .padding(.bottom, 4)
                        }
                    }
                }
            }
            .listStyle(SidebarListStyle())            
            .connectionBanner()
    }
}


struct OrganizationList_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let selectionModel:SelectionModel = SelectionModel()
        selectionModel.organization = organizationData.first
        selectionModel.product = productsData.first
        selectionModel.subproduct = subProductsData.first
        
        return Group {
            NavigationView {
                OrganizationList(selectionModel: selectionModel)
                    .environmentObject(OrganizationsQuery(withStaticOrganizations: organizationData, products: productsData, subProducts: subProductsData, andSections: sectionsData))
            }.environment(\.colorScheme, .light)
            
            NavigationView {
                OrganizationList(selectionModel: selectionModel)
                    .environmentObject(OrganizationsQuery(withStaticOrganizations: organizationData, products: productsData, subProducts: subProductsData, andSections: sectionsData))
            }.environment(\.colorScheme, .dark)
            
        }
    }
}

