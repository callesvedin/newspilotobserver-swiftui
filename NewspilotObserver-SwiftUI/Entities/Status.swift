//
//  Status.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-17.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
struct Status:Identifiable,Codable {
    let id:Int
    let entityType:String
    let name:String
    let color:Double
    
}
