//
//  PageFormatInfoFooter.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2020-01-18.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct PageFormatInfoFooter: View {
    private var backs:[BackKey:[Page]]
    private let backKeys:[BackKey]
    private var pageStatuses:[Int:Int] = [:]
    private var pageCount=0
    private let publicationStatus = 17
    private var statusArray:[Status] = []
    
    init(backs:[BackKey:[Page]], statusArray:[Status]) {
        self.backs = backs
        self.statusArray = statusArray
        backKeys = backs.map{$0.key}.sorted()
        for (_,pages) in backs {
            for page in pages {
                pageCount += 1
                if let count = pageStatuses[page.status] {
                    pageStatuses[page.status] = count + 1
                }else{
                    pageStatuses[page.status] = 1
                }
            }
        }
    }
    
    var body: some View {
        
//        GeometryReader {geometry in
//            VStack {
                //Spacer()
// Show a legend. But its too big to be used...
//                GridStack(rows: Int((Float(self.statusArray.count)/Float(2)).rounded(.up))  , columns: 2) {row, column in
//
//                    if self.statusArray.count > (row*2)+column
//                    {
////                        Text("R:\(row) C:\(column)")
//                        StatusInfo(status:self.statusArray[((row*2)+column)],  nrOfPages:self.pageStatuses[self.statusArray[row+column].id] ?? 0)
//                    }else{
//                        EmptyView()
//                    }
//                }
                
//                ForEach (self.statusArray) {status in
//                    StatusInfo(status:status,  nrOfPages:self.pageStatuses[status.id] ?? 0)
//                }
                
                Text("\(self.pageStatuses[self.publicationStatus] ?? 0) of \(self.pageCount) pages publicated")
                .background(Color(UIColor.systemBackground))
                .cornerRadius(10)
                .offset(y: 5)
//            }
            
//            }
    }
}

struct PageFormatInfoFooter_Previews: PreviewProvider {
    static var previews: some View {
        
        let view = PageFormatInfoFooter(
            backs: [pageData[0].backKey:pageData],
            statusArray: statusData
        ).border(Color.gray)
        return Group{
            view.previewDevice(PreviewDevice(rawValue: "iPhone SE")).previewDisplayName("iPhone SE")
            view.previewDevice(PreviewDevice(rawValue: "iPhone 11")).previewDisplayName("iPhone 11")
//            view.previewDevice(PreviewDevice(rawValue: "iPad")).previewDisplayName("iPad")
        }
    }
}

struct StatusInfo: View {
    let status:Status
    let nrOfPages:Int
    
    var body: some View {
        let statusColor = UIColor.intToColor(value: Int(status.color))
        return HStack {
            if status.color == -1 {
                Image.init(systemName: "circle")
                    .foregroundColor(Color(.black))
                    .font(.caption)
            }else{
                Image(systemName: "circle.fill")
                    .foregroundColor(Color(statusColor))
                    .font(.caption)
            }
            
            Text("= \(status.name)(\(String(nrOfPages)))")
                .font(.caption)
        }
    }
}
