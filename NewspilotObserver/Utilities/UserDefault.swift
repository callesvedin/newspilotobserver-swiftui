//
//  UserDefault.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-17.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
