//
//  PageDetailView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-29.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

protocol NameableView:View {
    var name:String { get }
}

struct PageDetailView: NameableView {
    let page:PageViewModel
    @State var infoViewShown = false
    
    var name:String {
        get {return page.name}
    }
    
    init(page:PageViewModel) {
        self.page = page
    }
    
    var body: some View {
        GeometryReader {geometry in
            ZStack() {
                VStack(alignment: .leading) {
                    
                    WebImage(url: self.page.previewUrl, options: [.highPriority, .allowInvalidSSLCertificates,.retryFailed])
                        .onSuccess { image, cacheType in
                            //print("loaded preview")
                    }
                        .resizable() // Resizable like SwiftUI.Image
                        .placeholder(Image(uiImage: UIImage(named: "EmptyPagePreview.png")!))
                        .indicator(.activity) // Activity Indicator
                        .animation(.easeInOut(duration: 0.5)) // Animation Duration
                        .transition(.fade) // Fade Transition
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: geometry.size.height-80, alignment: Alignment.center)
                }
                
                BottomSheetView(isOpen: self.$infoViewShown,
                                maxHeight: geometry.size.height * 0.7)
                {
                    PageInfoView(page:self.page)
                }
            }
            .connectionBanner()
        }
    }
}




