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
    let bannerData = BannerModifier.BannerData(title: "Connection Lost", detail: "Spoky", type: .Warning)
    
    var body: some View {
        List {
            organizationsList
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Organizations")
        .navigationBarBackButtonHidden(true)
//        .onReceive(self.loginHandler.$connectionStatus) {newState in
//            guard let connectionState = newState else {return}
//            switch connectionState {
//            case .notConnected,.connectionFailed, .authenticationFailed, .connecting:
//                self.connectionLost = true
//            case .connected:
//                self.connectionLost = false
//            }
//        }
            .connectionBanner()
//        .banner(data: self.bannerData, show: $connectionLost)
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
