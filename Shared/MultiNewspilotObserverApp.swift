//
//  MultiNewspilotObserverApp.swift
//  Shared
//
//  Created by carl-johan.svedin on 2020-09-14.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

@main
struct MultiNewspilotObserverApp: App {

    let organizationQuery:OrganizationsQuery
    let statusQuery:StatusQuery
    let pageFlagQuery:PageFlagQuery

    
    init() {
        let loginHandler = LoginHandler.shared
        organizationQuery = OrganizationsQuery(withNewspilot: loginHandler.newspilot)
        statusQuery = StatusQuery(withNewspilot: loginHandler.newspilot)
        pageFlagQuery = PageFlagQuery(withNewspilot: loginHandler.newspilot)
        PageQueryManager.shared.setup(withNewspilot: loginHandler.newspilot)
        PublicationDateQueryManager.shared.setup(withNewspilot: loginHandler.newspilot)
    }
    
    var body: some Scene {
        WindowGroup {
            ApplicationView()
                .environmentObject(statusQuery)
                .environmentObject(organizationQuery)
                .environmentObject(pageFlagQuery)
        }
    }
}
