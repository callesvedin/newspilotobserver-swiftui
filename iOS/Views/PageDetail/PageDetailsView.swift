//
//  PageDetailView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-29.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import SwiftUI


struct PageDetailsView<Pageable:NameableView>: View {
    
    var viewControllers: [UIHostingController<Pageable>]

    @State private var currentPage:Int
    
    init(_ views: [Pageable], currentPage:Int?) {
        self.viewControllers = views.map { UIHostingController(rootView: $0) }
        _currentPage = State(initialValue: currentPage ?? 0) // This is swifts weird way of representing the wrapper instead of its value (i think)
    }

    var body: some View {
        let dw = self.viewControllers[currentPage].rootView
        let title = dw.name 
        return PageViewController(controllers: viewControllers, currentPage: $currentPage).navigationBarTitle("\(title)")
    }
}
