//
//  ShapeExtensions.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2020-07-20.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import SwiftUI

extension Shape {
    /// fills and strokes a shape
    public func fill<S:ShapeStyle>(_ fillContent: S,
                                   opacity: Double,
                                   strokeWidth: CGFloat,
                                   strokeColor: S) -> some View
    {
        ZStack {
            self.fill(fillContent).opacity(opacity)
            self.stroke(strokeColor, lineWidth: strokeWidth)
        }
    }
}
