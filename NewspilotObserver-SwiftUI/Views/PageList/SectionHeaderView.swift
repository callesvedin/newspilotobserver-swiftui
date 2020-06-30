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
    @Binding var expandedBacks:Set<BackKey>
    
    var body : some View {
        GeometryReader {geometry in
        HStack {
            Text("Part: \(self.backKey.part ?? "-") Edition: \(self.backKey.edition ?? "-") Version:\(self.backKey.version ?? "-")")
            Spacer()
            
            Image(systemName: "chevron.right")
                .rotationEffect(.degrees(self.expandedBacks.contains(backKey) ? 90 : 0))
            
        }
        .font(Font.sectionHeaderFont)
        .padding(.horizontal,10)
        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        .onTapGesture {
            
            if (self.expandedBacks.contains(self.backKey)){
                withAnimation {
                    self.expandedBacks.remove(self.backKey)
                }
            }else{
                withAnimation {
                    self.expandedBacks.insert(self.backKey)
                }
            }
        }
        }
    }
}

struct SectionHeaderView_Previews: PreviewProvider {
    static let backs:Set<BackKey> = Set(arrayLiteral: BackKey(publicationDateId: 1, part: "A", version: "V1", edition: "E1"),
                                        BackKey(publicationDateId: 1, part: "A", version: "V2", edition: "E1"),
                                        BackKey(publicationDateId: 1, part: "B", version: "V1", edition: "E1"),
                                        BackKey(publicationDateId: 1, part: "B", version: "V1", edition: "E1"))
    
    static var previews: some View {
        Group {
            SectionHeaderView(backKey: backs.randomElement()!, expandedBacks: Binding.constant(backs))
                .previewDevice("iPhone 11")
            SectionHeaderView(backKey: backs.randomElement()!, expandedBacks: Binding.constant(backs))
                .previewDevice("iPad Pro (12.9-inch) (4th generation)")
        }
    }
}
