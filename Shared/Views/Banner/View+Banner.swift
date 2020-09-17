//
//  View+Banner.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2020-01-02.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func banner(data: BannerModifier.BannerData, show: Binding<Bool>) -> some View {
        self.modifier(BannerModifier(data: data, show: show))
    }
    
    func connectionBanner() -> some View {
        self.modifier(ConnectionModifier())
    }
}
