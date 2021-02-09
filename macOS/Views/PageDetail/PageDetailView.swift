//
//  PageDetailView.swift
//  NewspilotObserver (macOS)
//
//  Created by carl-johan.svedin on 2021-02-09.
//  Copyright © 2021 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct PageDetailView: View {
    
    let pageModel:PageViewModel
    
    
    var body: some View {
                
        GeometryReader {geometry in
            HSplitView {
                VStack(alignment:HorizontalAlignment.leading) {
                    Text(pageModel.name).font(.title).padding()
                    PageInfoView(page:pageModel)
                    Spacer()
                }
                .background(Color.white)
                .frame(width: 250)
                
                WebImage(url: self.pageModel.previewUrl, options: [.highPriority, .allowInvalidSSLCertificates,.retryFailed])
                    .onSuccess { image, cacheType in
                        //print("loaded preview")
                }
                .resizable() // Resizable like SwiftUI.Image
                .placeholder(Image(uiImage: UIImage(named: "EmptyPagePreview.png")!))
                .indicator(.activity) // Activity Indicator
                .animation(.easeInOut(duration: 0.5)) // Animation Duration
                .transition(.fade) // Fade Transition
                .scaledToFit()
//                .frame(width: geometry.size.width-200, height: geometry.size.height, alignment: Alignment.center)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct PageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let m = PageViewModel(id:1,pageNumber: 1,name: "First News page",section: "Section", part: "part", edition: "Ed 1",
                              version: "Version",template: "Template",
                              editionType: EditionType.original, statusName: "StatusOk",
                              statusColor: NSColor.green, flags: [NSImage(systemSymbolName: "star", accessibilityDescription:"TestImage"), NSImage(systemSymbolName: "star.fill", accessibilityDescription:"TestImage")],
                              thumbUrl: nil, previewUrl: nil)
        PageDetailView(pageModel:m).frame(width: 750, height: 800, alignment: .center)
    }
}
