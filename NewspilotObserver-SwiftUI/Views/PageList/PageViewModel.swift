//
//  PageCellViewModel.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-17.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import UIKit

struct PageViewModel : Identifiable {
    let id:Int
    let pageNumber:Int
    let name:String
    let section:String?
    let part:String?
    let edition:String?
    let version:String?
    let template:String?
    let editionType:EditionType
    let statusName:String
    let statusColor:UIColor
    let flags:[UIImage?]
    let thumbUrl:URL?
    let previewUrl:URL?     
}

enum EditionType:Int {
    case original = 0
    case identical = 1
    case basedOn = 2
    
    var stringValue:String {
        get {
            switch self {
            case .original:
                return "Original"
            case .basedOn:
                return "Based on"
            case .identical:
                return "Identical"
            }
        }
    }
}

