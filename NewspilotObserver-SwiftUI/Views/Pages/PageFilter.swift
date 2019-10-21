//
//  PageFilter.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-21.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation

class PageFilter:ObservableObject {
    @Published var publicationDateId:Int = -1
    @Published var version:String = ""
    @Published var edition:String = ""
    @Published var part:String = ""
}
