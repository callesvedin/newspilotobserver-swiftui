//
//  ApplicationView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-12-17.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct ApplicationView: View {
    @ObservedObject var loginHandler = LoginHandler.shared
    var body: some View {
        Group {
            if loginHandler.loggedIn {
                NavigationView {
                    OrganizationList()
                    HStack(alignment: .center) {
                        Image(systemName: "arrow.left")
                        Text("Select organization")
                        Spacer()
                    }
                    .padding()
                    .font(.headline)
                }
            }else{
                NavigationView {
                    LoginView()
                }.navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
}

struct ApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationView()
    }
}
