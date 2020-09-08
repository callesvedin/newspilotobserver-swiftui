//
//  FlagsView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-11-26.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import SwiftUI


struct FlagsView:View {
    let key:String
    let flags:[UIImage?]
    
    var body: some View {
        HStack {
            Text(self.key).bold()
            Spacer()
            HStack (spacing:0) {
                ForEach (0..<self.flags.count) {index in
                    FlagIcon(flag:self.flags[index])
                }
            }
        }
    }
}

