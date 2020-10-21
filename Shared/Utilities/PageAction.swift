//
//  PageAction.swift
//  NewspilotObserver
//
//  Created by carl-johan.svedin on 2020-10-20.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation

enum ActionType {
    case None
    case ChangeStatus
}

class PageAction : ObservableObject {
    @Published var type:ActionType = .None
    var page:Page?
}
