//
//  PageListCell.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-17.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct PageCollectionCell: View {
    let page:PageViewModel
    
    init(page:PageViewModel) {
        self.page = page
    }
    
    var body: some View {
            VStack(spacing:0) {
                WebImage(url: self.page.thumbUrl, options: [.highPriority, .allowInvalidSSLCertificates,.retryFailed])
                    .onSuccess { image, cacheType in
//                        print("loaded preview")
                }
                    .resizable() // Resizable like SwiftUI.Image
                    .placeholder(Image(uiImage: UIImage(named: "EmptyPageThumb.png")!))
                    .indicator(.activity) // Activity Indicator
                    .scaledToFit()
                
                Rectangle().frame(width: nil, height: 5, alignment: .top).foregroundColor(Color(self.page.statusColor)).padding(.top, 4).padding(.horizontal, 4)
                    Text("\(self.page.name)").font(.caption).foregroundColor(Color.primary)
                    
                
                //                    HStack(spacing:0) {
                //
                //                        ForEach (0..<self.page.flags.count, id:\.self) {index in
                //                            FlagIcon(flag:self.page.flags[index])
                //                        }
                //                    }
                
                
            }        

    }
    
}

struct PageCollectionCell_Previews: PreviewProvider {
    static var previews: some View {
        let model = PageViewModel(id: 1, pageNumber: 4, name: "Great page", section: "Section A", part: "Part A", edition: "Edition 1", version: "Version 3",template: "A-Section",editionType: .original, statusName: "Ready", statusColor: UIColor.green,flags:[UIImage(systemName: "star"), UIImage(systemName: "star.fill")],
                                  thumbUrl: nil, previewUrl: nil)
        return PageCollectionCell(page: model).previewLayout(.fixed(width: 200, height: 300)) //.border(Color.gray)
    }
}
