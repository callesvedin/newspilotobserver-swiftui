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

    @State private var currentPage:Int
    
    init(_ views: [Pageable], currentPage:Int) {
        self.viewControllers = views.map { UIHostingController(rootView: $0) }
        _currentPage = State(initialValue: currentPage) // This is swifts weird way of representing the wrapper instead of its value (i think)
    }

    var body: some View {
        PageViewController(controllers: viewControllers, currentPage: $currentPage)
    }
}
