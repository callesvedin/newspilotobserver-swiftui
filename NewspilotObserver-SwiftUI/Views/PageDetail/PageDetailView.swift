//
//  PageDetailView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-29.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct PageDetailView: View {
    let page:Page
//    let name:String
    
    init(page:Page) {
        self.page = page
    }
    
    var body: some View {
        Text("Hello \(page.name)")
    }
}

//struct PageDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PageDetailView(page:Page())
//    }
//}
