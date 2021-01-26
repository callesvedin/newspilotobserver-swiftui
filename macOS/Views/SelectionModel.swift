//
//  SelectionModel.swift
//  NewspilotObserver (macOS)
//
//  Created by carl-johan.svedin on 2021-01-14.
//  Copyright © 2021 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation

class SelectionModel:ObservableObject {
    @Published var organization:Organization?
    @Published var product:Product?
    @Published var subproduct:SubProduct?
}
