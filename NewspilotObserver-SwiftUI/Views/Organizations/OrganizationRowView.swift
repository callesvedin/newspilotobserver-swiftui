//
//  OrganizationRowView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-06.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct OrganizationRowView: View {
    
    var viewModel:OrganizationRowViewModel?
    
    init(viewModel:OrganizationRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("Hello Organization")
    }
}

//struct OrganizationRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrganizationRowView()
//    }
//}
