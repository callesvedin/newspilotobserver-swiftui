//
//  Calendar+StartStop.swift
//  NewspilotObserver
//
//  Created by carl-johan.svedin on 2018-09-17.
//  Copyright © 2018 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation

extension Calendar {
    public func beginningOf(date:Date) -> Date? {
        var fromComponents = self.dateComponents([.year, .month, .day], from: date)
        fromComponents.hour = 0
        fromComponents.minute = 0
        fromComponents.second = 0
        fromComponents.timeZone = TimeZone.init(identifier: "GMT")
        return self.date(from: fromComponents)
    }
    
    public func endOf(date:Date) -> Date? {
        var fromComponents = self.dateComponents([.year, .month, .day], from: date)
        fromComponents.hour = 23
        fromComponents.minute = 59
        fromComponents.second = 59
        fromComponents.timeZone = TimeZone.init(identifier: "GMT")
        return self.date(from: fromComponents)

    }

}
