//
//  OrganizationsQuery.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-06.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import Newspilot
import OSLog
import Combine

class OrganizationsQuery {
    
    private var newspilotManager:NewspilotManager    
    var organizations:[Organization] = []
    var cancellableSubscriber:Cancellable?
    var publisher:CurrentValueSubject<[Organization], Never>
    
    private var query:Query? {
        didSet {
            if query == nil {
                cancellableSubscriber?.cancel()
            }else{
                cancellableSubscriber = self.query!.events.sink(receiveCompletion: { completion in
                    os_log("OrganizationQuery got completed", log:.newspilot, type:.debug)
                }, receiveValue: {events in
                    self.process(events)
                })
            }
        }
    }
    
    
    private let organizationsQueryString = """
        <query type="Organization" version="1.1">
            <structure>
                <entity type="Organization">
                    <entity parent="organization.id" type="Product">
                        <entity parent="product.id" type="SubProduct"/>
                        <entity parent="product.id" type="Section"/>
                    </entity>
                </entity>
            </structure>
            <base-query>
                <and>
                    <ne field="id" type="Organization" value="-1"/>
                </and>
            </base-query>
            <sub-query type="Product">
                <eq field="mediaId" type="Product" value="1"/>
            </sub-query>
        </query>
        """
    
    
    init(withNewspilotManager newspilotManager:NewspilotManager) {
        self.newspilotManager = newspilotManager
        self.publisher = CurrentValueSubject<[Organization],Never>([])
        newspilotManager.newspilot.addQuery(queryString: organizationsQueryString, completionHandler: {result in
            switch (result) {
            case .failure(let error):
                os_log("Could not add query. Error:%@", log: .newspilot, type:.error, error.localizedDescription)
            case .success(let query):
                self.query = query                
            }
            
        })
    }
    
    private func process(_ events:[Event]) {
        events.forEach({ (event) in
                os_log("Processing organization event from newspilot. EntityType: %@ , EntityId: %ld", log: .newspilot, type: .debug, event.entityType.rawValue, event.entityId)
                switch event.eventType {

                case .CREATE:
                    let decoder = JSONDecoder()
                    if event.entityType == .Organization {
                        if let organization = try? decoder.decode(Organization.self, from: JSONSerialization.data(withJSONObject: event.values, options: [])) {
                            print("We got an organization with the name \(organization.name)")
                            self.organizations.append(organization)
                        }
                    }
//                    self.fixStructure(entity: entity, values: event.values, managedObjectContext: managedObjectContext)

//                case .CHANGE:
//                    if let _entity = entity {
//                        _entity.data = try? JSONSerialization.data(withJSONObject: event.values, options: [])
//                        self.fixStructure(entity: _entity, values: event.values, managedObjectContext: managedObjectContext)
//                    }
//
//                case .REMOVE:
//                    if let _entity = entity {
//                        managedObjectContext.delete(_entity)
//                    }
//                    return
//                }
                default:
                    os_log("Unhandled entitytype in OrganizationQuery", log: .newspilot, type:.error)

            }
        })
        publisher.send(self.organizations)
    }
    
}
