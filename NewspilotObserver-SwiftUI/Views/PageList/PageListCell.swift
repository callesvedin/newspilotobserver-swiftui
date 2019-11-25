//
//  PageListCell.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-17.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct PageListCell: View {
    let page:PageViewModel
        
    var body: some View {
        GeometryReader {geometry in
            HStack {
                Rectangle()
                    .fill(Color(self.page.statusColor))
                    .position(x: 3, y: geometry.size.height/2)
                    .frame(width: 6, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)

                    //         pageImage?.sd_setImage(with: url, placeholderImage: placeholderImage, options: [.highPriority, .allowInvalidSSLCertificates,.retryFailed], completed: { (image, error, cacheType, url) in

                WebImage(url: self.page.thumbUrl, options: [.highPriority, .allowInvalidSSLCertificates,.retryFailed])
                                          .onSuccess { image, cacheType in
//                                              print("loaded preview")
                                          }
                                          .resizable() // Resizable like SwiftUI.Image
                                          .placeholder(Image(uiImage: UIImage(named: "EmptyPageThumb.png")!))
                                          // Supports ViewBuilder as well
                                          .placeholder {
                                              Rectangle().foregroundColor(.gray)
                                          }
                                          .indicator(.activity) // Activity Indicator
                                          .animation(.easeInOut(duration: 0.5)) // Animation Duration
                                          .transition(.fade) // Fade Transition
                                          .scaledToFit()
                        .frame(width: 50, height: geometry.size.height, alignment: Alignment.center)
                
                VStack(alignment: .leading) {
                    Text("\(self.page.name)")
                    HStack {
                        if self.page.section != nil {
                            Text(self.page.section!).font(.caption)
                        }
                        Text("\(self.page.flags.count)")
                    }
                }
                Spacer()
            }
        }
    }
}

struct PageListCell_Previews: PreviewProvider {
    static var previews: some View {
        let model = PageViewModel(id: 1, name: "Great page", section: "Section A", part: "Part A", edition: "Edition 1", version: "Version 3",template: "A-Section",editionType: .original, statusColor: UIColor.green,flags:[UIImage(systemName: "star"), UIImage(systemName: "star.fill")],
                                  thumbUrl: nil, previewUrl: nil)
        return PageListCell(page: model).previewLayout(.fixed(width: 300, height: 50))
    }
}
