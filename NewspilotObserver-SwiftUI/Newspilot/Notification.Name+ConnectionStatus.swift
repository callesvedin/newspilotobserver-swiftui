//
//  Notification.Name+ConnectionStatus.swift
//  NewspilotObserver
//
//  Created by carl-johan.svedin on 2019-02-27.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let ConnectionFailed = Notification.Name("ConnectionFailed")
    static let DidConnect = Notification.Name("DidConnect")    
}
