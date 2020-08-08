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
    let page:PageViewModel?
    
    init(page:PageViewModel?) {
        self.page = page
    }
    
    var body: some View {
        
        HStack (alignment: .top){
            if page != nil {
                VStack (spacing:0){
                    ForEach (0..<self.page!.flags.count, id:\.self) {index in
                        FlagIcon(flag:self.page!.flags[index])
                    }
                }
                .frame(minWidth: 18, maxWidth: 20, minHeight: 20, maxHeight: 200, alignment: Alignment.top)
                
                VStack(alignment: .center, spacing:0) {
                    ZStack(alignment: .bottomTrailing){
                        WebImage(url: self.page!.thumbUrl, options: [.highPriority, .allowInvalidSSLCertificates,.retryFailed])
                            .onSuccess { image, cacheType in
                                //                        print("loaded preview")
                            }
                            .resizable()
                            .placeholder(Image(uiImage: UIImage(named: "EmptyPageThumb.png")!))
                            .indicator(.activity)
                            .scaledToFit()
                            .shadow(radius: 5)
                        Text("\(self.page!.pageNumber)")
                            .font(.caption)
                            .bold()
                            .padding(2)
                            .background(Color(self.page!.statusColor).opacity(0.4))
                            .padding(2)
                    }
                    
                    HStack {
                        Text("\(self.page!.name)")
                            .font(.caption)
                            .padding(.top, 4)
                        Spacer()
                    }
                    
                }
                
            }
        }
        
    }
    
}

struct PageCollectionCell_Previews: PreviewProvider {
    static var previews: some View {
        let model = PageViewModel(id: 1, pageNumber: 1, name: "Great page", section: "Section A", part: "Part A", edition: "Edition 1", version: "Version 3",template: "A-Section",editionType: .original, statusName: "Ready", statusColor: UIColor.green,flags:[UIImage(systemName: "star"), UIImage(systemName: "star.fill")],
                                  thumbUrl: nil, previewUrl: nil)
        return
            Group {
                PageCollectionCell(page: model).previewLayout(.fixed(width: 200, height: 300))
                PageCollectionCell(page: model).previewLayout(.fixed(width: 300, height: 400))
                PageCollectionCell(page: model).previewLayout(.fixed(width: 200, height: 300))
                    .previewDisplayName("Dark")
                    .environment(\.colorScheme, .dark)
                PageCollectionCell(page: model).previewLayout(.fixed(width: 300, height: 400))
                    .previewDisplayName("Dark")
                    .environment(\.colorScheme, .dark)

        } //.border(Color.gray)
    }
}
