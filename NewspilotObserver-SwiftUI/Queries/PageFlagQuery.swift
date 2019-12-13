//
//  FlagQuery.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-11-18.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//




import Foundation
import Newspilot
import os.log
import Combine
import UIKit

class PageFlagQuery :  ObservableObject {
    
    @Published var flags:[EntityFlag] = []
    
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
                    os_log("FlagQuery got completed", log:.newspilot, type:.debug)
                }, receiveValue: {events in
                    os_log("FlagQuery events received", log:.newspilot, type:.debug)
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
        <query type="EntityFlag" version="1.1">
        <structure>
        <entity type="EntityFlag"/>
        </structure>
        <base-query>
        <and>
        <eq field="type" type="EntityFlag" value="Page"/>
        </and>
        </base-query>
        </query>
        """
    }
    
    private func process(_ events:[Event]) {
        events.forEach({ (event) in
            os_log("Processing flag event from newspilot. EntityType: %@ , EntityId: %d", log: .newspilot, type: .debug, event.entityType.rawValue, event.entityId)
//            os_log("Values %@",log:.newspilot, type:.debug, event.values)
            do {
                let data = try JSONSerialization.data(withJSONObject: event.values, options: [])
                let decoder = JSONDecoder()
                var flag = try decoder.decode(EntityFlag.self, from: data)
                
                switch event.eventType {
                case .CREATE:
                    switch event.entityType {
                    case .EntityFlag:
                        os_log("We got a flag with the name  %@", log: .newspilot, type: .debug, flag.name)
                        if flag.onSymbol != nil {
                            let createdImageData = createImageData(fromBase64: flag.onSymbol)
                            if let imageData = createdImageData {
                                flag.setOnImage(UIImage(data:imageData))
                            }
                        }
                        if let i = flags.firstIndex(where:{$0.id == event.entityId}) {
                            flags[i] = flag
                        }else{
                            self.flags.append(flag)
                        }
                    default:
                        os_log("Got event entity type not handled:  %@", log: .newspilot, type: .error, event.entityType.rawValue)
                    }
                    
                case .CHANGE:
                    switch (event.entityType) {
                    case .EntityFlag:
                        if let i = flags.firstIndex(where:{$0.id == event.entityId}) {
                            if flag.onSymbol != nil {
                                let createdImageData = createImageData(fromBase64: flag.onSymbol)
                                if let imageData = createdImageData {
                                    flag.setOnImage(UIImage(data:imageData))
                                }
                            }
                            flags[i] = flag
                        }
                    default:
                        os_log("Can not change %@", log: .newspilot, type: .error, event.entityType.rawValue)
                    }
                case .REMOVE:
                    switch (event.entityType) {
                    case .EntityFlag:
                        flags.removeAll(where:{$0.id == event.entityId})
                    default:
                        os_log("Can not remove  %@", log: .newspilot, type: .error, event.entityType.rawValue)
                    }
                default:
                    os_log("Unhandled event in FlagQuery", log: .newspilot, type:.error)
                    
                }
            }catch(let error) {
                os_log("Could not decode Flag. %@", log: .newspilot, type: .error, error.localizedDescription)                
            }
            
        })
    }
    
    func createImageData(fromBase64 _base64:String?) -> Data? {
        guard let base64 = _base64 else {
            return nil;
        }
        
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters) ?? nil
    }
    
}

