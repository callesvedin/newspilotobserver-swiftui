//
//  FlagIcon.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-11-26.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import SwiftUI


struct FlagIcon : View {
    let flag:UIImage?
    
    var body:some View {
        Group {
            if flag != nil {
                Image.init(uiImage: self.flag!).frame(width: 16, height: 16, alignment: Alignment.center)
            }else{
                Image.init(systemName: "star")                
            }
        }
    }
}
