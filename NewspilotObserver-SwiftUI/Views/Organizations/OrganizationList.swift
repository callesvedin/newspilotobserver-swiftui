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
    @EnvironmentObject var loginHandler:LoginHandler
    @EnvironmentObject var organizationQuery:OrganizationsQuery
    @EnvironmentObject var statusQuery:StatusQuery
    @EnvironmentObject var flagQuery:PageFlagQuery
    @State var connectionLost:Bool = false
    
    var body: some View {
        List {
            organizationsList
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Organizations")
        .navigationBarBackButtonHidden(true)
        .connectionBanner()
    }
}

private extension OrganizationList {    
    var organizationsList: some View {
        ForEach(organizationQuery.organizations) {organization in
            Section(header: Text(organization.name).bold()) {
                ForEach(self.organizationQuery.getProducts(for: organization)){product in
                    NavigationLink(destination: SubProductList(product:product,
                        publicationDateQuery: PublicationDateQuery(withNewspilot: self.loginHandler.newspilot, productId: product.id))) {
                                                                ProductRow(product:product)
                    }.isDetailLink(false)
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
