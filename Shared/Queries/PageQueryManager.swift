//
//  PageQueryFactory.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2020-03-19.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import Newspilot

class PageQueryManager { // Rename to manager
    private var newspilot:Newspilot?
    private var queries:[PageQuery]=[]
    public static let shared = PageQueryManager()
    
    private init() {}
    
    func setup(withNewspilot newspilot:Newspilot) {
            self.newspilot = newspilot
    }
    
    public func getPageQuery(withProductId productId:Int, subProductId:Int) -> PageQuery {
        if newspilot == nil {
            fatalError("Newspilot not set on PageQueryManager")
        }
        if let query = queries.first(where: {query in query.productId == productId && query.subProductId == subProductId}) {
            return query
        }else{
            let query = PageQuery(withNewspilot: newspilot!, productId: productId, subProductId: subProductId, publicationDateId: 0)
            queries.append(query)
            return query
        }
    }
    
    
}
