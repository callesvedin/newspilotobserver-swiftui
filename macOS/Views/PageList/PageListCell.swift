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
import Cocoa

struct PageListCell: View {
    let page:PageViewModel
    let placeholderImage = Image(nsImage: UIImage(named: "EmptyPageThumb.png")!)
    
    init(page:PageViewModel) {
        self.page = page
    }
        
    var body: some View {
            HStack {
                Rectangle()
                    .fill(Color(self.page.statusColor))
                    .frame(width: 10)

                WebImage(url: self.page.thumbUrl, options: [.highPriority, .allowInvalidSSLCertificates,.retryFailed])
                                          .onSuccess { image, cacheType in
//                                              print("loaded preview")
                                          }
                                          .resizable() // Resizable like SwiftUI.Image
                                          .placeholder(placeholderImage)
                                          .indicator(.activity) // Activity Indicator
                                          .animation(.easeInOut(duration: 0.2)) // Animation Duration
                                          .transition(.fade) // Fade Transition
                                          .scaledToFit()
                        .frame(width: 50, alignment: Alignment.center)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(self.page.name)").font(.bodyFont)
                    HStack(spacing:0) {
                        if self.page.section != nil {
                            Text(self.page.section!).font(.smallBodyFont)
                        }
                        Spacer()

                        ForEach (0..<self.page.flags.count, id:\.self) {index in
                            FlagIcon(flag:self.page.flags[index])
                        }
                    }
                }
            }
            .padding(4)
            .background(
                Color(.windowBackgroundColor)
                .shadow(color: Color.gray, radius: 2, x: 4, y: 2)
            )
            .padding(.horizontal, 4)
    }
}

struct PageListCell_Previews: PreviewProvider {
    static var previews: some View {
        
        
        let m = PageViewModel(id:1,pageNumber: 1,name: "First News page",section: "Section", part: "part", edition: "Ed 1",
                              version: "Version",template: "Template",
                              editionType: EditionType.original, statusName: "StatusOk",
                              statusColor: NSColor.green, flags: [NSImage(systemSymbolName: "star", accessibilityDescription:"TestImage"), NSImage(systemSymbolName: "star.fill", accessibilityDescription:"TestImage")],
                              thumbUrl: nil, previewUrl: nil)
        let m2 = PageViewModel(id:1,pageNumber: 2,name: "Second News page",section: "Section", part: "part", edition: "Ed 1",
                              version: "Version",template: "Template",
                              editionType: EditionType.original, statusName: "StatusOk",
                              statusColor: NSColor.green, flags: [NSImage(systemSymbolName: "star", accessibilityDescription:"TestImage"), NSImage(systemSymbolName: "star.fill", accessibilityDescription:"TestImage")],
                              thumbUrl: nil, previewUrl: nil)
        
        return
            Group {
                List{
                    PageListCell(page: m)
                    PageListCell(page: m2)
                }
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light Mode")

                List{
                    PageListCell(page: m)
                    PageListCell(page: m2)
                }
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")


            }
    }
}
