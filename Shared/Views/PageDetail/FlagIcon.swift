//
//  FlagIcon.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-11-26.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import SwiftUI
#if os(macOS)
import Cocoa
#else
import UIKit
#endif


struct FlagIcon : View {
    #if os(macOS)
    let flag:NSImage?
    #else
    let flag:UIImage?
    #endif
    
    
    var body:some View {
        Group {
            if flag != nil {
                #if os(macOS)
                Image.init(nsImage: self.flag!).frame(width: 16, height: 16, alignment: Alignment.center)
                #else
                Image.init(uiImage: self.flag!).frame(width: 16, height: 16, alignment: Alignment.center)
                #endif
            }else{
                Image.init(systemName: "star")                
            }
        }
    }
}
