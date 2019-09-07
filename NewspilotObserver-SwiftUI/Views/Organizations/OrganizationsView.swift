//
//  OrganizationsView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-06.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct OrganizationsView: View {
    @ObservedObject var viewModel:OrganizationsViewModel
    
    init(viewModel:OrganizationsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
          if viewModel.dataSource.isEmpty {
            emptySection
          } else {
            organizationsList
          }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Weather ⛅️")
    }
}

private extension OrganizationsView {
  var emptySection: some View {
      Text("No results (yet)")
        .foregroundColor(.gray)
  }
    
    var organizationsList: some View {
        ForEach(viewModel.dataSource, content: OrganizationRowView.init(viewModel:))
    }
}

//struct OrganizationsView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrganizationsView(viewModel: OrganizationsViewModel(query: OrganizationsQuery(withNewspilotManager: NewspilotManager())))
//    }
//}
