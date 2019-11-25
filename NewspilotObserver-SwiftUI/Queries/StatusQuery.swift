//
//  PublicationDateQuery.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-04.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import Newspilot
import os.log
import Combine

class StatusQuery :  ObservableObject {
    
    @Published var statuses:[Status] = []
    
    var externalQueryId:String!
    var cancellableSubscriber:Cancellable?
    var loaded:Bool = false
    
    private let newspilot:Newspilot!
    
    private var query:Query? {
        didSet {
            if query == nil {
                cancellableSubscriber?.cancel()
            }else{
                cancellableSubscriber = self.query!.events.receive(on: RunLoop.main).sink(receiveCompletion: { completion in
                    os_log("StatusQuery got completed", log:.newspilot, type:.debug)
                }, receiveValue: {events in
                    os_log("StatusQuery events received", log:.newspilot, type:.debug)
                    self.process(events)
                })
            }
        }
    }
    
    
    init(withNewspilot newspilot:Newspilot?) {
        self.newspilot = newspilot
        load()
    }
    
    func load() {
        if !loaded {
            let queryString = getQueryString()
            if queryString != nil {
                if query != nil && externalQueryId != nil {
                    self.newspilot.removeQuery(withQuid: externalQueryId)
                    query = nil
                }
                self.externalQueryId = UUID().uuidString
                
                newspilot.addQuery(withExternalId:self.externalQueryId, queryString: queryString!, completionHandler: {result in
                    switch (result) {
                    case .failure(let error):
                        os_log("Could not add query. Error:%@", log: .newspilot, type:.error, error.localizedDescription)
                    case .success(let query):
                        self.query = query                        
                        self.loaded = true
                    }
                })
            }else{
                os_log("Could not create publication date query", log:.newspilot, type:.error)
            }
        }
    }
    
    private func getQueryString() -> String? {
        
        return """
            <query type="Status" version="1.1">
                <structure>
                    <entity type="Status"/>
                </structure>
                <base-query>
                    <and>
                        <ne field="id" type="Status" value="-1"/>
                        <eq field="type" type="Status" value="5"/>
                    </and>
                </base-query>
            </query>
        """
        
    }
    
    private func process(_ events:[Event]) {
        events.forEach({ (event) in
            os_log("Processing status event from newspilot. EntityType: %@ , EntityId: %ld", log: .newspilot, type: .debug, event.entityType.rawValue, event.entityId)
//            os_log("Values %@",log:.newspilot, type:.debug, event.values)
            do {
                let data = try JSONSerialization.data(withJSONObject: event.values, options: [])
                let decoder = JSONDecoder()
                let status = try decoder.decode(Status.self, from: data)
                
                switch event.eventType {
                case .CREATE:
                    switch event.entityType {
                    case .Status:
                        os_log("We got a status with the name %@", log: .newspilot, type:.debug, status.name)
                        
                        if let i = statuses.firstIndex(where:{$0.id == event.entityId}) {
                            statuses[i] = status
                        }else{
                            self.statuses.append(status)
                        }
                    default:
                        os_log("Got event entity type not handled:%@", log: .newspilot, type:.error, event.entityType.rawValue)
                    }
                    
                case .CHANGE:
                    switch (event.entityType) {
                    case .Status:
                        if let i = statuses.firstIndex(where:{$0.id == event.entityId}) {
                            statuses[i] = status
                        }
                    default:
                        os_log("Can not change:%@", log: .newspilot, type:.error, event.entityType.rawValue)
                    }
                case .REMOVE:
                    switch (event.entityType) {
                    case .Status:
                        statuses.removeAll(where:{$0.id == event.entityId})
                    default:
                        os_log("Can not remove:%@", log: .newspilot, type:.error, event.entityType.rawValue)
                    }
                default:
                    os_log("Unhandled event in StatusQuery", log: .newspilot, type:.error)
                    
                }
            }catch(let error) {
                os_log("Could not decode Status. Error:%@", log: .newspilot, type:.error, error.localizedDescription)                
            }
            
        })
    }
    
    
}

