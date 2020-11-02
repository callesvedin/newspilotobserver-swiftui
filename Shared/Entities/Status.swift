//
//  Status.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-17.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
#if os(macOS)
import Cocoa
#else
import UIKit
#endif


struct Status:Identifiable,Codable,Comparable {
    static func < (lhs: Status, rhs: Status) -> Bool {
        return lhs.sortKey < rhs.sortKey
    }
    
    let id:Int
    let entityType:String
    let name:String
    let color:Double
    let sortKey:Int

    enum CodingKeys: String, CodingKey {
     case id
     case entityType
     case name
     case color
     case sortKey = "sort_key"
    }
    
}

extension Status {
    var statusColor:UIColor {
        get {UIColor.intToColor(value: Int(color))}
    }
}
