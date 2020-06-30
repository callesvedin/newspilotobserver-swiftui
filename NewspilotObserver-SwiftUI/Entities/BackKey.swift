//
//  BackKey.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-24.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation

struct BackKey:PageFilterable {    
//    let id:String = UUID().uuidString
    let publicationDateId:Int
    let part:String?
    let version:String?
    let edition:String?
}

extension BackKey:Equatable, Comparable {
    static func < (lhs: BackKey, rhs: BackKey) -> Bool {
        
        if rhs.publicationDateId != lhs.publicationDateId {
            return lhs.publicationDateId < rhs.publicationDateId
        }
        
        let partCompared = compareParts(lhs.part, rhs.part)
        if partCompared != .orderedSame {
            return partCompared.rawValue < 0
        }

        let editionCompared = compareParts(lhs.edition, rhs.edition)
        if editionCompared != .orderedSame {
            return editionCompared.rawValue < 0
        }

        let versionCompared = compareParts(lhs.version, rhs.version)
        if versionCompared != .orderedSame {
            return versionCompared.rawValue < 0
        }
        return false
    }
    
    static private func compareParts(_ lhsPart:String?, _ rhsPart:String?) -> ComparisonResult {
        if lhsPart == nil && rhsPart == nil {
            return ComparisonResult.orderedSame
        }else if lhsPart != nil && rhsPart == nil {
            return ComparisonResult.orderedAscending
        }else if rhsPart != nil && lhsPart == nil {
            return ComparisonResult.orderedDescending
        }else{
            return lhsPart!.compare(rhsPart!)
        }
        
    }
    
    static func == (lhs: BackKey, rhs: BackKey) -> Bool {
        return lhs.hashValue == rhs.hashValue
//        return lhs.part == rhs.part
//            && lhs.edition == rhs.edition
//            && lhs.version == rhs.version
    }
}

extension BackKey:Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(publicationDateId)
        hasher.combine(part)
        hasher.combine(edition)
        hasher.combine(version)
    }
}

extension BackKey:CustomStringConvertible {
    var description: String {
        return "PiD\(publicationDateId) P\(part ?? "-")V\(version ?? "-")E\(edition ?? "-")"
    }
}
