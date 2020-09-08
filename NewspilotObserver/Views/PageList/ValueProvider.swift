//
//  ValueProvider.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-11-03.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import SwiftUI

protocol ValueViewProvider {
    associatedtype ValueType
    associatedtype AView:View
    
    func valueView(parameter:ValueType) -> AView
}
