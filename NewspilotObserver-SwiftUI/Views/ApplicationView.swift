//
//  ApplicationView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-12-17.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct ApplicationView: View {
    @EnvironmentObject var loginHandler:LoginHandler
    
    var body: some View {
        Group {
            if loginHandler.connectionStatus == .connected {
                NavigationView { OrganizationList()
                    .environmentObject(OrganizationsQuery(withNewspilot: loginHandler.newspilot))
                    .environmentObject(StatusQuery(withNewspilot: loginHandler.newspilot))
                    .environmentObject(PageFlagQuery(withNewspilot: loginHandler.newspilot))
                }
            }else{
                LoginView()
            }
        }
    }
}

struct ApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationView().environmentObject(LoginHandler())
    }
}
