//
//  UIColor.swift
//  NewspilotObserver (macOS)
//
//  Created by carl-johan.svedin on 2020-11-03.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import AppKit

typealias UIColor = NSColor

extension NSColor {
    
    static var label:NSColor {
        return NSColor.labelColor
    }
    

    static var tertiaryLabel:NSColor {
        return NSColor.tertiaryLabelColor
    }
    
   static var secondarySystemBackground: NSColor {
       return NSColor.underPageBackgroundColor
   }

   static var tertiarySystemBackground: NSColor {
       return NSColor.controlBackgroundColor
   }
    
    
    static var systemBackground:NSColor {
        return NSColor.windowBackgroundColor
    }
    static var tertiarySystemFill:NSColor {
        return NSColor.textBackgroundColor //Change?
    }
    
}
