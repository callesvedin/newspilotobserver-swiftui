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
    @StateObject var selectionModel = SelectionModel()
    
    var body: some View {
        Group {
            if loginHandler.loggedIn {
                NavigationView {
                    OrganizationList(selectionModel: self.selectionModel)
                    if (selectionModel.product != nil) {
                        SubProductList(selectionModel: self.selectionModel)
                    }
                    if (selectionModel.subproduct != nil) {
                        PageList(newspilot: loginHandler.newspilot, subProduct: selectionModel.subproduct!,
                                 pageQuery: PageQueryManager.shared.getPageQuery(withProductId: selectionModel.subproduct!.productID, subProductId: selectionModel.subproduct!.id)
                        )
                    }

//
//                    HStack(alignment: .center) {
//                        if #available(OSX 11.0, *) {
//                            Image(systemName: "arrow.left")
//                        } else {
//                            Image("arrow.left") // Imported as a supporting format like PDF (not SVG)
//                        }
//
//                        Text("Select organization")
//                        Spacer()
//                    }
//                    .padding()
//                    .font(.headline)
                }
//                .navigationViewStyle(DoubleColumnNavigationViewStyle())
            }else{
                LoginView()
            }
        }
    }
}

struct ApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationView()
    }
}
