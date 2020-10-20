//
//  NewspilotManager.swift
//  NewspilotObserver
//
//  Created by carl-johan.svedin on 2020-10-12.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import Newspilot
import os.log
import Combine

class NewspilotManager {
    static let shared = Newspilot()

    public static func setPageStatus(_ status:Int, forPageId pageId:Int) {
        print("Now requesting set status \(status) on page \(pageId)")
        do {
        let publisher = try shared.makeRequest(method: .PUT,
                                           path: "/newspilot/rest/entities/Page/\(pageId)",
                                           body: NewspilotManager.createUpdateStructure(entityType:"Page", entityId:pageId, values:["status": status]))
        _ = publisher.sink(receiveCompletion: {completion in
            switch completion {
            case .finished:
                os_log("Set status completed", log:.newspilot, type:.debug)
            case .failure(let error):
                os_log("Set status failed. %@", log:.newspilot, type:.error, error.localizedDescription)
            }
        }, receiveValue: {data in
            
        })
            
        }catch (let error) {
            os_log("Set status though exception. %@", log:.newspilot, type:.error, error.localizedDescription)
        }
        
    }
    
    public static func createUpdateStructure(entityType:String, entityId:Int, values:[String:Any]) throws -> String {
        var newValues = values
        newValues["entityType"] = entityType
        newValues["id"] = entityId
        
        let jsonData = try JSONSerialization.data(withJSONObject: newValues, options: [])
//        if let jsonData = try? encoder.encode(newValues) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        
        throw NewspilotError.conversionError(errorMessage: "Could not create update structure")
    }
}

