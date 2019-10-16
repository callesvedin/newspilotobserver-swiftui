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

class PublicationDateQuery :  ObservableObject {
    
    @Published var publicationDates:[PublicationDate] = []
    var sortedPublicationDates:[PublicationDate] {
        get {
            return publicationDates.sorted {date1,date2 in
                date1.pubDate < date2.pubDate
            }
        }
    }
    var externalQueryId:String!
    var cancellableSubscriber:Cancellable?
    var loaded:Bool = false
    private let newspilotDateFormatter:DateFormatter
    private let newspilot:Newspilot!
    private let productId:Int
    
    private var query:Query? {
        didSet {
            if query == nil {
                cancellableSubscriber?.cancel()
            }else{
                cancellableSubscriber = self.query!.events.receive(on: RunLoop.main).sink(receiveCompletion: { completion in
                    os_log("PublicationDateQuery got completed", log:.newspilot, type:.debug)
                }, receiveValue: {events in
                    os_log("PublicationDateQuery events received", log:.newspilot, type:.debug)
                    self.process(events)
                })
            }
        }
    }
    
    
    init(withNewspilot newspilot:Newspilot?, productId:Int) {
        self.newspilot = newspilot
        self.productId = productId
        self.newspilotDateFormatter = DateFormatter()
        self.newspilotDateFormatter.timeZone = TimeZone(identifier: "UTC")
        self.newspilotDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
        
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.beginningOf(date: Date()) ?? Date()
        let aMonthAgo = calendar.date(byAdding: .month, value: -1, to: today, wrappingComponents: false)
        let nextYear = calendar.date(byAdding: .month, value: 3, to: today, wrappingComponents: false)
        
        guard let fromDate = aMonthAgo, let toDate = nextYear else {
            os_log("Could not create beginning and end of date for publication dates", log: .newspilot, type: .error)
            return nil
        }
        
        let fromString = newspilotDateFormatter.string(from: fromDate)
        let toString = newspilotDateFormatter.string(from: toDate)
                
        return """
            <query type="PublicationDate" version="1.1">
                <structure>
                    <entity type="PublicationDate"/>
                </structure>
                <base-query>
                    <and>
                        <eq field="product.id" type="PublicationDate" value="\(self.productId)"/>
                        <between field="pubDate" type="PublicationDate" value1="\(fromString)" value2="\(toString)"/>
                    </and>
                </base-query>
            </query>
            """
    
    }
    
    private func process(_ events:[Event]) {
        events.forEach({ (event) in
            os_log("Processing publication date event from newspilot. EntityType: %@ , EntityId: %ld", log: .newspilot, type: .debug, event.entityType.rawValue, event.entityId)
            os_log("Values %@",log:.newspilot, type:.debug, event.values)
            do {
                let data = try JSONSerialization.data(withJSONObject: event.values, options: [])
                let decoder = JSONDecoder()
                let publicationDate = try decoder.decode(PublicationDate.self, from: data)
                
                switch event.eventType {
                case .CREATE:
                    switch event.entityType {
                    case .PublicationDate:
                        print("We got an publication date with the name \(publicationDate.name ?? "")")
                        if let i = publicationDates.firstIndex(where:{$0.id == event.entityId}) {
                            publicationDates[i] = publicationDate
                        }else{
                            self.publicationDates.append(publicationDate)
                        }
                    default:
                        print("Got event entity type not handled:\(event.entityType)")
                    }
                    
                case .CHANGE:
                    switch (event.entityType) {
                    case .PublicationDate:                        
                        if let i = publicationDates.firstIndex(where:{$0.id == event.entityId}) {
                            publicationDates[i] = publicationDate
                        }
                    default:
                        print("Can not change \(event.entityType)")
                    }
                case .REMOVE:
                    switch (event.entityType) {
                    case .PublicationDate:
                        publicationDates.removeAll(where:{$0.id == event.entityId})
                    default:
                        print("Can not remove \(event.entityType)")
                    }
                default:
                    os_log("Unhandled event in PublicationDateQuery", log: .newspilot, type:.error)
                    
                }
            }catch(let error) {
                print("Could not decode PublicationDate. \(error)")
            }
            
        })
    }
    
    
}

