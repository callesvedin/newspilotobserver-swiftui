//
//  PageFilter.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-21.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import Newspilot

protocol PageFilterable {
    var publicationDateId:Int { get }
    var version:String? { get }
    var edition:String? { get }
    var part:String? { get }
}

class PageFilter:ObservableObject {
//    @Published var publicationDateId:Int = -1
    @Published var publicationDate:PublicationDate? = nil
    @Published var version:String? = nil
    @Published var edition:String? = nil
    @Published var part:String? = nil
}

extension PageFilter {
    func match(_ page:PageFilterable ) -> Bool {
        if (publicationDate != nil && publicationDate!.id != page.publicationDateId) {
            return false
        }
        if (version != nil && version! != page.version) {
            return false
        }
        if (edition != nil && edition! != page.edition) {
            return false
        }
        
        if (part != nil && part! != page.part) {
            return false
        }

        return true
    }
}
//
//extension PageFilter {
//    func match(_ backKey:BackKey ) -> Bool {
//        if (publicationDate != nil && publicationDate!.id != backKey.publicationDateId) {
//            return false
//        }
//        if (version != nil && version! != backKey.version) {
//            return false
//        }
//        if (edition != nil && edition! != backKey.edition) {
//            return false
//        }
//
//        if (part != nil && part! != backKey.part) {
//            return false
//        }
//
//        return true
//    }
//}
