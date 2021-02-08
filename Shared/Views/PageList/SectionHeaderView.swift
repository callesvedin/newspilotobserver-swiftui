//
//  SectionHeaderView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2020-06-28.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
struct SectionHeaderView:View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let backKey:BackKey
//    @Binding var expandedBacks:Set<BackKey>
//    let expandedBacks:Set<BackKey> //Använd en bool istället....
    let expanded:Bool
        
    #if os(macOS)
    let sectionBackgroundColor = NSColor.systemBackground
    #else
    let sectionBackgroundColor = UIColor.systemBackground
    #endif

    var body : some View {
        VStack {
            Spacer()
            HStack {
                Text("Part: \(self.backKey.part ?? "-") Edition: \(self.backKey.edition ?? "-") Version:\(self.backKey.version ?? "-")")
                Spacer()
                
                Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(self.expanded ? 90 : 0))
            }
            .font(Font.sectionHeaderFont)
            .foregroundColor(Color.secondary)
            .padding(.horizontal,10)
            
            Spacer()
        }
        .listRowInsets(EdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0))
//        .background(colorScheme == .light ? Color.white : Color(sectionBackgroundColor))
        .background(Color.clear)
        
    }
    
}

struct SectionHeaderView_Previews: PreviewProvider {
    static let backs:Set<BackKey> = Set(arrayLiteral: BackKey(publicationDateId: 1, part: "A", version: "V1", edition: "E1"),
                                        BackKey(publicationDateId: 1, part: "A", version: "V2", edition: "E1"),
                                        BackKey(publicationDateId: 1, part: "B", version: "V1", edition: "E1"),
                                        BackKey(publicationDateId: 1, part: "B", version: "V1", edition: "E1"))
    
    static var previews: some View {
        #if os(macOS)
            let devices = ["macOs"]
        #else
            let devices  = ["iPhone 11","iPad Pro (12.9-inch) (4th generation)"]
        #endif
        return ForEach (devices, id: \.self) {device in
            SectionHeaderView(backKey: backs.randomElement()!, expanded: true)
                .previewDisplayName(device)
                .previewDevice(PreviewDevice(rawValue:device))
            SectionHeaderView(backKey: backs.randomElement()!, expanded: false)
                .environment(\.colorScheme, .dark)
                .previewDisplayName(device)
                .previewDevice(PreviewDevice(rawValue:device))

        }
    }
}
