//
//  PageDetailView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-29.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

protocol NameableView:View {
    var name:String { get }
}

struct PageDetailView: NameableView {
    let page:PageViewModel
    @State var infoViewShown = false
    
    var name:String {
        get {return page.name}
    }
    
    init(page:PageViewModel) {
        self.page = page
    }
    
    var body: some View {
        GeometryReader {geometry in
            ZStack() {
                VStack(alignment: .leading) {
                    
                    WebImage(url: self.page.previewUrl, options: [.highPriority, .allowInvalidSSLCertificates,.retryFailed])
                        .onSuccess { image, cacheType in
                            //print("loaded preview")
                    }
                        .resizable() // Resizable like SwiftUI.Image
                        .placeholder(Image(uiImage: UIImage(named: "EmptyPagePreview.png")!))
                        .indicator(.activity) // Activity Indicator
                        .animation(.easeInOut(duration: 0.5)) // Animation Duration
                        .transition(.fade) // Fade Transition
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: geometry.size.height-80, alignment: Alignment.center)
                }
                
                BottomSheetView(isOpen: self.$infoViewShown,
                                maxHeight: geometry.size.height * 0.7)
                {
                    InfoView(page:self.page)
                }
            }
            .connectionBanner()
        }
    }
}


struct InfoView: View {
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
    let color:UIColor
    
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




