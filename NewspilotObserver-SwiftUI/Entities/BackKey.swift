//
//  BackKey.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-24.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation

struct BackKey {
//    let id:String = UUID().uuidString
    let part:String?
    let version:String?
    let edition:String?
}

extension BackKey:Equatable {
    static func == (lhs: BackKey, rhs: BackKey) -> Bool {
        return lhs.hashValue == rhs.hashValue
//        return lhs.part == rhs.part
//            && lhs.edition == rhs.edition
//            && lhs.version == rhs.version
    }
}

extension BackKey:Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(part)
        hasher.combine(edition)
        hasher.combine(version)
    }
}
