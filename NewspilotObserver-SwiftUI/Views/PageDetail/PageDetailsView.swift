//
//  PageDetailView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-29.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import SwiftUI


struct PageDetailsView<Pageable:View>: View {
    
    var viewControllers: [UIHostingController<Pageable>]
    @State var currentPage = 0
    
    init(_ views: [Pageable], currentPage:Int) {
        self.viewControllers = views.map { UIHostingController(rootView: $0) }
        self.currentPage = currentPage
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            PageViewController(controllers: viewControllers, currentPage: $currentPage)
            PageControl(numberOfPages: viewControllers.count, currentPage: $currentPage)
        }
    }
}
