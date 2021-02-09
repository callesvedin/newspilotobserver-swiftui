//
//  DetailedViewController.swift
//  NewspilotObserver (macOS)
//
//  Created by carl-johan.svedin on 2021-02-09.
//  Copyright © 2021 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
import Cocoa


class DetailWindowController<RootView : View>: NSWindowController {
    convenience init(rootView: RootView) {
        let hostingController = NSHostingController(rootView: rootView.frame(minWidth: 500, idealWidth:800, minHeight: 600, idealHeight: 800))
        let window = NSWindow(contentViewController: hostingController)
        window.minSize = NSSize(width: 500, height: 600)
        
        self.init(window: window)
    }
}
