//
//  PageListCell.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-17.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Newspilot

struct PageListCell: View {
    let page:PageViewModel
    #if os(macOS)
    let placeholderImage = Image(nsImage: UIImage(named: "EmptyPageThumb.png")!)
    #else
    let placeholderImage = Image(uiImage: UIImage(named: "EmptyPageThumb.png")!)
    #endif
    
    init(page:PageViewModel) {
        self.page = page
    }
        
    var body: some View {
        
            HStack {
                Rectangle()
                    .fill(Color(self.page.statusColor))
                    .frame(width: 5)

                WebImage(url: self.page.thumbUrl, options: [.highPriority, .allowInvalidSSLCertificates,.retryFailed])
                                          .onSuccess { image, cacheType in
//                                              print("loaded preview")
                                          }
                                          .resizable()
                                          .placeholder(placeholderImage)
                                          .indicator(.activity) // Activity Indicator
                                          .animation(.easeInOut(duration: 0.2)) // Animation Duration
                                          .transition(.fade) // Fade Transition
                                          .scaledToFit()
                        .frame(width: 30, alignment: Alignment.center)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(self.page.name)")
                    HStack(spacing:0) {
                        if self.page.section != nil {
                            Text(self.page.section!).font(.smallBodyFont)
                        }
                        Spacer()                    

                        ForEach (0..<self.page.flags.count, id:\.self) {index in
                            FlagIcon(flag:self.page.flags[index]).padding(.horizontal, 4)
                        }
                    }

                }
            }.padding(.vertical,2)
        
    }
}

struct PageListCell_Previews: PreviewProvider {
    static var previews: some View {
        
        let m = PageViewModel(id:1,pageNumber: 2,name: "PageName",section: "Section 2",part: "part", edition: "Ed 1",version: "Version",template: "Template",editionType: EditionType.original,statusName: "StatusOk",statusColor: UIColor.green,flags: [UIImage(systemName: "star"), UIImage(systemName: "star.fill")], thumbUrl: nil, previewUrl: nil)
        
//        let model = PageViewModel(id: 1, pageNumber: 2, name: "Great page", section: "Section A",
//                                  part: "Part A", edition: "Edition 1", version: "Version 3",template: "A-Section",editionType: .original,
//                                  statusName: "Ready", statusColor: UIColor.green,
//                                  flags:[UIImage(systemName: "star"), UIImage(systemName: "star.fill")],
//                                  thumbUrl: nil, previewUrl: nil)

//        let model2 = PageViewModel(id: 2, pageNumber: 3, name: "Great page", section: "Section A", part: "Part A", edition: "Edition 1", version: "Version 3",template: "A-Section",editionType: .original, statusName: "Ready", statusColor: UIColor.green,flags:[UIImage(systemName: "star"), UIImage(systemName: "star.fill")],
//                                  thumbUrl: nil, previewUrl: nil)

        return
            NavigationView {
                List{
                    PageListCell(page: m).frame(height:50)
//            PageListCell(page: model2)
                }
            }
            
            
    }
}
