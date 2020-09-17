//
//  PublicationDateQueryManager.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2020-05-06.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import Newspilot

class PublicationDateQueryManager {
    private var newspilot:Newspilot?
    private var queries:[PublicationDateQuery]=[]
    public static let shared = PublicationDateQueryManager()
    
    private init() {}
    
    func setup(withNewspilot newspilot:Newspilot) {
            self.newspilot = newspilot
    }
    
    public func getPublicationDateQuery(withProductId productId:Int) -> PublicationDateQuery {
        if newspilot == nil {
            fatalError("Newspilot not set on PageQueryManager")
        }
        if let query = queries.first(where: {query in query.productId == productId}) {
            return query
        }else{
            let query = PublicationDateQuery(withNewspilot: newspilot!, productId: productId)
            queries.append(query)
            return query
        }
    }
    
    
}
