//
//  OrganizationRowView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-06.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct OrganizationRow: View {
    
    let viewModel:OrganizationRowViewModel
    
    init(viewModel:OrganizationRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Section(header: Text(viewModel.name).bold()) {
            ForEach(viewModel.products, content: ProductRow.init(product:))
        }
    }
}


struct OrganizationRowView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationRow(viewModel: OrganizationRowViewModel(id: 1, name: "West Coast News", products: [ProductRowViewModel(id: 1, name: "GP")]))
    }
}
