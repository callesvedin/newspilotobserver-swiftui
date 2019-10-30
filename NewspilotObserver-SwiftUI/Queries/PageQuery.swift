//
//  PublicationDateQuery.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-04.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import Newspilot
import OSLog
import Combine

class PageQuery : ObservableObject {
    
    @Published var backs:[BackKey:[Page]] = [:]    
    
    var externalQueryId:String!
    var cancellableSubscriber:Cancellable?
    var loaded:Bool = false
    
    private let newspilot:Newspilot
    private let productId:Int
    private let subProductId:Int
    var publicationDateId:Int {
        didSet {
            loaded = false
            load()
        }
    }
    
    private var query:Query? {
        didSet {
            if query == nil {
                cancellableSubscriber?.cancel()
            }else{
                cancellableSubscriber = self.query!.events.receive(on: RunLoop.main).sink(receiveCompletion: { completion in
                    os_log("PageQuery got completed", log:.newspilot, type:.debug)
                }, receiveValue: {events in
                    os_log("PageQuery events received", log:.newspilot, type:.debug)
                    self.process(events)
                })
            }
        }
    }
    
    
    init(withNewspilot newspilot:Newspilot, productId:Int, subProductId:Int, publicationDateId:Int) {
        self.newspilot = newspilot
        self.productId = productId
        self.subProductId = subProductId
        self.publicationDateId = publicationDateId
    }
    
    func cancel() {
        cancellableSubscriber?.cancel()
        loaded = false
        backs = [:]
    }
    
    func load() {
        if !loaded {
            let queryString = getQueryString()

            self.backs = [:]
            if query != nil && externalQueryId != nil {
                self.newspilot.removeQuery(withQuid: externalQueryId)
                query = nil
            }
            self.externalQueryId = UUID().uuidString
            if queryString != nil {
                newspilot.addQuery(withExternalId: externalQueryId ,queryString: queryString!, completionHandler: {result in
                    switch (result) {
                    case .failure(let error):
                        os_log("Could not add query. Error:%@", log: .newspilot, type:.error, error.localizedDescription)
                    case .success(let query):
                        self.query = query
                        self.loaded = true
                    }
                })
            }else{
                os_log("Could not create page query", log:.newspilot, type:.error)
            }
        }
    }
    
    private func getQueryString() -> String? {
                        
        return """
        <query type="Page" version="1.1">
            <structure>
                <entity type="Page"/>
            </structure>
            <base-query>
                <and>
                    <eq field="product.id" type="Page" value="\(productId)"/>
                    <ne field="preproductionType" type="Page" value="1"/>
                    <eq field="publicationDate.id" type="Page" value="\(publicationDateId)"/>
                    <eq field="subProduct.id" type="Page" value="\(subProductId)"/>
                </and>
            </base-query>
        </query>
        """
    
    }
    
    private func process(_ events:[Event]) {
        events.forEach({ (event) in
            os_log("Processing page event from newspilot. EntityType: %@ , EntityId: %ld", log: .newspilot, type: .debug, event.entityType.rawValue, event.entityId)
            os_log("Values %@",log:.newspilot, type:.debug, event.values)
            do {
                let data = try JSONSerialization.data(withJSONObject: event.values, options: [])
                let decoder = JSONDecoder()
                let page = try decoder.decode(Page.self, from: data)
                
                switch event.eventType {
                case .CREATE:
                    switch event.entityType {
                    case .Page:
                        print("We got an page with the name \(page.name)")
                        var backList = backs[page.backKey]
                        if backList == nil {
                            backList = [page]
                            backs[page.backKey] = backList
                        }else if let i = backList!.firstIndex(where:{$0.id == event.entityId}) {
                            backs[page.backKey]![i] = page
                        }else{
                            backs[page.backKey]!.append(page)
                        }
                    default:
                        print("Got event entity type not handled:\(event.entityType)")
                    }
                    
                case .CHANGE:
                    switch (event.entityType) {
                    case .Page:
                        var backList = backs[page.backKey, default:[]]
                        if let i = backList.firstIndex(where:{$0.id == event.entityId}) {
                            backList[i] = page
                        }
                    default:
                        print("Can not change \(event.entityType)")
                    }
                case .REMOVE:
                    switch (event.entityType) {
                    case .Page:
                        var backList = backs[page.backKey, default:[]]
                        backList.removeAll(where:{$0.id == event.entityId})
                    default:
                        print("Can not remove \(event.entityType)")
                    }
                default:
                    os_log("Unhandled event in PageQuery", log: .newspilot, type:.error)
                    
                }
            }catch(let error) {
                print("Could not decode Page. \(error)")
            }
            
        })
    }
    
    private func createBacks(pages:[Page]) -> [BackKey:[Page]] {
        var backs:[BackKey:[Page]] = [:]
        
        for page in pages {
            let pageBackKey = page.backKey
            backs[pageBackKey, default:[]].append(page)
        }
        return backs
    }
    
}

