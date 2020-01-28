//
//  PageFormatInfoFooter.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2020-01-18.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct PageFormatInfoFooter: View {
    public var backs:[BackKey:[Page]]
    private let backKeys:[BackKey]
    private var statuses:[Int:Int] = [:]
    private var pageCount=0
    private let publicationStatus = 25
    
    init(backs:[BackKey:[Page]]) {
        self.backs = backs
        backKeys = backs.map{$0.key}.sorted()
        for (_,pages) in backs {
            for page in pages {
                pageCount += 1
                if let count = statuses[page.status] {
                   statuses[page.status] = count + 1
                }else{
                    statuses[page.status] = 1
                }
            }
        }
    }
    
    var body: some View {
        
        GeometryReader {geometry in
            VStack {
                Spacer()
                Text("\(self.statuses[self.publicationStatus] ?? 0) of \(self.pageCount) pages publicated")
                .frame(width: geometry.size.width, height: 50, alignment: .center)
                                                                                                                                                                                .background(Color(UIColor.systemBackground))
                .cornerRadius(10)
                .offset(y: 5)
                }
            
            }
    }
}

struct PageFormatInfoFooter_Previews: PreviewProvider {
    static var previews: some View {
        
        PageFormatInfoFooter(
            backs: [pageData[0].backKey:pageData]
        ).previewDevice(PreviewDevice(rawValue: "iPhone SE")).previewDisplayName("iPhone SE")
    }
}
