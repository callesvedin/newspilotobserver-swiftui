//
//  File.swift
//  NewspilotObserver
//
//  Created by carl-johan.svedin on 2021-02-09.
//  Copyright © 2021 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import SwiftUI

struct PageInfoView: View {
    let page:PageViewModel
    
    var body: some View {
        #if !os(macOS)
        UITableView.appearance().backgroundColor = .clear // tableview background
        UITableViewCell.appearance().backgroundColor = .clear // cell background
        #endif
        return List {
            KeyValueView(key:"Name", value:page.name)
            KeyValueView(key:"Part", value:page.part)
            KeyValueView(key:"Edition", value:page.edition)
            KeyValueView(key:"Version", value:page.version)
            KeyValueView(key:"Section", value:page.section)
            KeyValueView(key:"Template", value:page.template)
            KeyValueView(key:"Edition Type", value: page.editionType.stringValue)
            KeyColorValueView(key:"Status", name:page.statusName, color: page.statusColor)
            FlagsView(key:"Flags", flags:page.flags)
                
            
        } //.background(Color. edgesIgnoringSafeArea(.all))
    }
}

//struct PageDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let view = PageDetailView(page:PageViewModel(id: 1, pageNumber: 4, name: "Great page", section: "Section A",
//                                                     part: "Part A", edition: "Edition 1", version: "Version 3", template: "A-Section",
//                                                     editionType: .identical, statusName: "Ready",
//                                                     statusColor: UIColor.green, flags:[UIImage(systemName: "star"), UIImage(systemName: "star.fill")], thumbUrl: nil, previewUrl: nil)
//        )
//        return Group {
//            view.previewDevice(PreviewDevice(rawValue: "iPhone SE")).previewDisplayName("iPhone SE")
//            view.previewDevice(PreviewDevice(rawValue: "iPhone XS Max")).previewDisplayName("iPhone XS Max")
//        }
//    }
//}

struct KeyValueView: View {
    let key:String
    let value:String?
    
    var body: some View {
        HStack {
            Text(self.key).bold()
            Spacer()
            if value != nil{
                Text(self.value!)
            }
        }
    }
}

struct KeyColorValueView: View {
    let key:String
    let name:String
    #if os(macOS)
    let color:NSColor
    #else
    let color:UIColor
    #endif
    
    
    var body: some View {
        HStack {
            Text(self.key).bold()
            Spacer()
            Text(self.name).foregroundColor(.gray)
            if color == .white {
                Image.init(systemName: "circle").foregroundColor(Color.black)
            }else {
                Image.init(systemName: "circle.fill").foregroundColor(Color(color))
            }
        }
    }
}
