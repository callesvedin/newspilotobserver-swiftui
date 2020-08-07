//
//  SectionHeaderView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2020-06-28.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
struct SectionHeaderView:View {
    let backKey:BackKey
//    @Binding var expandedBacks:Set<BackKey>
    let expandedBacks:Set<BackKey> //Använd en bool istället....
    var body : some View {
        
        HStack {
            Text("Part: \(self.backKey.part ?? "-") Edition: \(self.backKey.edition ?? "-") Version:\(self.backKey.version ?? "-")")
            Spacer()
            
            Image(systemName: "chevron.right")
                .rotationEffect(.degrees(self.expandedBacks.contains(backKey) ? 90 : 0))
            
        }
        .font(Font.sectionHeaderFont)
        .padding(.horizontal,10)
    }
    
}

struct SectionHeaderView_Previews: PreviewProvider {
    static let backs:Set<BackKey> = Set(arrayLiteral: BackKey(publicationDateId: 1, part: "A", version: "V1", edition: "E1"),
                                        BackKey(publicationDateId: 1, part: "A", version: "V2", edition: "E1"),
                                        BackKey(publicationDateId: 1, part: "B", version: "V1", edition: "E1"),
                                        BackKey(publicationDateId: 1, part: "B", version: "V1", edition: "E1"))
    
    static var previews: some View {
        Group {
            SectionHeaderView(backKey: backs.randomElement()!, expandedBacks: backs)
                .previewDevice("iPhone 11")
            SectionHeaderView(backKey: backs.randomElement()!, expandedBacks: backs)
                .previewDevice("iPad Pro (12.9-inch) (4th generation)")
        }

//        Group {
//            SectionHeaderView(backKey: backs.randomElement()!, expandedBacks: Binding.constant(backs))
//                .previewDevice("iPhone 11")
//            SectionHeaderView(backKey: backs.randomElement()!, expandedBacks: Binding.constant(backs))
//                .previewDevice("iPad Pro (12.9-inch) (4th generation)")
//        }
    }
}
