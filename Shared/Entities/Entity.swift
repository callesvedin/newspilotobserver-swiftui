//
//  Entity.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-06.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation

class Entity {
    let id:Int
    let entityType:EntityType
    var name:String
    
    init(entityType:EntityType, id:Int, name:String) {
        self.id = id
        self.entityType = entityType
        self.name = name
    }
}
