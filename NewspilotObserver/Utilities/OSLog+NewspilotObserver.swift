import Foundation
import os

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let ui = OSLog(subsystem: subsystem, category: "UI")
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let newspilot = OSLog(subsystem: subsystem, category: "Newspilot")
    static let coreData = OSLog(subsystem: subsystem, category: "CoreData")
}
