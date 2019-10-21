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
    let page:PageCellViewModel
    
    
    var body: some View {
        GeometryReader {geometry in
            HStack {
                Rectangle()
                    .fill(Color(self.page.statusColor))
                    .position(x: 3, y: geometry.size.height/2)
                    .frame(width: 6, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)

                    //         pageImage?.sd_setImage(with: url, placeholderImage: placeholderImage, options: [.highPriority, .allowInvalidSSLCertificates,.retryFailed], completed: { (image, error, cacheType, url) in

                WebImage(url: self.page.thumbUrl, placeholder: Image(uiImage: UIImage(named: "EmptyPageThumb.png")!), options: [.highPriority, .allowInvalidSSLCertificates,.retryFailed])
                    .onSuccess(perform: { (image, cacheType) in
                        print("Loaded image with cacheType \(cacheType)")
                    })
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: geometry.size.height, alignment: Alignment.center)
//                    .frame(minWidth: 0, idealWidth: 50, maxWidth: 100, minHeight: geometry.size.height-10, idealHeight: geometry.size.height, maxHeight: geometry.size.height, alignment: Alignment.center)
//                Image(uiImage: self.page.icon).resizable().frame(width: 30, height: 50, alignment: Alignment.center)
                VStack(alignment: .leading) {
                    Text("\(self.page.name)")
                    HStack {
                        Text(self.page.section).font(.caption)
                        //FlagView(page.flags)
                    }
                }
                Spacer()
            }
        }
    }
}

struct PageListCell_Previews: PreviewProvider {
    static var previews: some View {
        PageListCell(page: PageCellViewModel(id: 1, name: "My page name", section: "News", statusColor:UIColor.green)).previewLayout(.fixed(width: 300, height: 50))
    }
}
