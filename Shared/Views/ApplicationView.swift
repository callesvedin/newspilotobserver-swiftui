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
                        if #available(OSX 11.0, *) {
                            Image(systemName: "arrow.left")
                        } else {
                            Image("arrow.left") // Imported as a supporting format like PDF (not SVG)
                        }
                        
                        Text("Select organization")
                        Spacer()
                    }
                    .padding()
                    .font(.headline)
                }
            }else{
                #if os(macOS)
                NavigationView {
                    LoginView()
                }
                .navigationViewStyle(DefaultNavigationViewStyle())
                #else
                NavigationView {
                    LoginView()
                }
                .navigationViewStyle(StackNavigationViewStyle())
                #endif
            }
        }
    }
}

struct ApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationView()
    }
}
