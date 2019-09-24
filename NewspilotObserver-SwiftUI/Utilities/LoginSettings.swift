//
//  LoginSettings.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-17.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import Combine

final class LoginSettings: ObservableObject {
    let didChange = PassthroughSubject<Void, Never>()

    init(){
        
    }
    init(login:String, server:String) {
        self.login = login
        self.server = server
    }
    
    @UserDefault("login", defaultValue: "")
    var login: String {
        didSet {
            didChange.send()
        }
    }
    
    @UserDefault("server", defaultValue: "")
    var server: String {
        didSet {
            didChange.send()
        }
    }
}
