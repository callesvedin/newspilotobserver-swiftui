//
//  PageDetailView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-29.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct PageDetailView: View {
    let page:PageViewModel
    
    init(page:PageViewModel) {
        self.page = page
    }
    
    var body: some View {
        GeometryReader {geometry in
            VStack {
        WebImage(url: self.page.previewUrl, placeholder: Image(uiImage: UIImage(named: "EmptyPagePreview.png")!), options: [.highPriority, .allowInvalidSSLCertificates,.retryFailed])
            .onSuccess(perform: { (image, cacheType) in
                print("loaded preview")
            })
            .resizable()
            .scaledToFit()
            .frame(width: geometry.size.width, height: geometry.size.height-10, alignment: Alignment.center)
            }
        }
    }
}

//struct PageDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PageDetailView(page:Page())
//    }
//}
