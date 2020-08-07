//
//  OrganizationsQuery.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-06.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import Newspilot
import os.log
import Combine

class OrganizationsQuery :  ObservableObject {
    
    var objectWillChange = PassthroughSubject<Void, Never>()
    
    var organizations:[Organization] = []
    var products:[Product] = []
    var subProducts:[SubProduct] = []
    var sections:[NewspilotSection] = []
    
    var externalQueryId:String!
    var cancellableSubscriber:Cancellable?
    var loaded:Bool = false
    private weak var newspilot:Newspilot?
    
    
    private var query:Query? {
        didSet {
            if query == nil {
                cancellableSubscriber?.cancel()
            }else{
                cancellableSubscriber = self.query!.events.receive(on: RunLoop.main).sink(receiveCompletion: { completion in
                    os_log("OrganizationQuery got completed", log:.newspilot, type:.debug)
                }, receiveValue: {events in
                    os_log("OrganizationQuery events received", log:.newspilot, type:.debug)
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
    
    
    init(withNewspilot newspilot:Newspilot) {
        self.newspilot = newspilot
        load()
    }
    
    init(withStaticOrganizations organizations:[Organization], products:[Product], subProducts:[SubProduct], andSections sections:[NewspilotSection]) {
        self.organizations = organizations
        self.products = products
        self.subProducts = subProducts
        self.sections = sections
    }
    
    func load() {
        guard let localNewspilot = newspilot else {
            os_log("Can not load query when newspilot is nil", log:.newspilot, type:.default)
            return
        }
        if !loaded {
            if query != nil && externalQueryId != nil {
                localNewspilot.removeQuery(withQuid: externalQueryId)
                query = nil
            }
            self.externalQueryId = UUID().uuidString
            localNewspilot.addQuery(withExternalId:self.externalQueryId, queryString: organizationsQueryString, completionHandler: {[weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch (result) {
                case .failure(let error):
                    os_log("Could not add query. Error:%@", log: .newspilot, type:.error, error.localizedDescription)
                case .success(let query):
                    strongSelf.query = query
                    strongSelf.loaded = true
                }
            })
        }
    }
    
    
    private func process(_ events:[Event]) {
        
        events.forEach({ (event) in
            os_log("Processing organization event from newspilot. EntityType: %@ , EntityId: %d", log: .newspilot, type: .debug, event.entityType.rawValue, event.entityId)
            do {
                let data = try JSONSerialization.data(withJSONObject: event.values, options: [])
                let decoder = JSONDecoder()
                
                switch event.eventType {
                case .CREATE:
                    switch event.entityType {
                    case .Organization:
                        
                        let organization = try decoder.decode(Organization.self, from: data)
                        os_log("We got an organization with the name %@", log: .newspilot, type: .debug, organization.name)
                        
                        if let i = organizations.firstIndex(where:{$0.id == event.entityId}) {
                            self.organizations[i] = organization
                        }else{
                            organizations.append(organization)
                        }
                        let organizationProducts = products.filter({product in product.organizationID == organization.id})
                        organization.products.append(contentsOf: organizationProducts)
                    case .Product:
                        
                        let product = try decoder.decode(Product.self, from: data)
                        os_log("We got a product with the name %@", log: .newspilot, type: .debug, product.name)
                        if let organization = self.organizations.first(where: {organization in product.id == organization.id}) {
                            organization.products.append(product)
                        }
                        if let i = products.firstIndex(where:{$0.id == event.entityId}) {
                            products[i] = product
                        }else{
                            self.products.append(product)
                        }
                    case .SubProduct:
                        let subProduct = try decoder.decode(SubProduct.self, from: data)
                        os_log("We got a sub product with the name %@", log: .newspilot, type: .debug, subProduct.name)
                        if let i = subProducts.firstIndex(where:{$0.id == event.entityId}) {
                            subProducts[i] = subProduct
                        }else{
                            subProducts.append(subProduct)
                        }
                    case .Section:
                        let section = try decoder.decode(NewspilotSection.self, from: data)
                        os_log("We got a section with the name %@", log: .newspilot, type: .debug, section.name)
                        
                        if let i = sections.firstIndex(where:{$0.id == event.entityId}) {
                            sections[i] = section
                        }else{
                            sections.append(section)
                        }
                    default:
                        os_log("Got event entity type not handled: %@", log: .newspilot, type: .error, event.entityType.rawValue)
                    }
                    
                case .CHANGE:
                    switch (event.entityType) {
                    case .Organization:
                        let organization = try decoder.decode(Organization.self, from: data)
                        
                        if let i = organizations.firstIndex(where:{$0.id == event.entityId}) {
                            organizations[i] = organization
                        }
                    case .Product:
                        let product = try decoder.decode(Product.self, from: data)
                        
                        if let i = products.firstIndex(where:{$0.id == event.entityId}) {
                            products[i] = product
                        }
                    case .SubProduct:
                        let subproduct = try decoder.decode(SubProduct.self, from: data)
                        
                        if let i = subProducts.firstIndex(where:{$0.id == event.entityId}) {
                            subProducts[i] = subproduct
                        }
                    case .Section:
                        let section = try decoder.decode(NewspilotSection.self, from: data)
                        
                        if let i = sections.firstIndex(where:{$0.id == event.entityId}) {
                            sections[i] = section
                        }
                    default:
                        os_log("Can not change %@", log: .newspilot, type: .error, event.entityType.rawValue)
                    }
                case .REMOVE:
                    switch (event.entityType) {
                    case .Organization:
                        organizations.removeAll(where:{$0.id == event.entityId})
                    case .Product:
                        products.removeAll(where:{$0.id == event.entityId})
                    case .SubProduct:
                        subProducts.removeAll(where:{$0.id == event.entityId})
                    case .Section:
                        sections.removeAll(where:{$0.id == event.entityId})
                    default:
                        os_log("Can not remove %@", log: .newspilot, type: .error, event.entityType.rawValue)
                    }                    
                }
            }catch(let error) {
                os_log("Could not process event %@", log: .newspilot, type: .error, error.localizedDescription)
            }
            
        })
        objectWillChange.send()
    }
    
    
    func getOrganizations() -> [Organization] {
        return organizations
    }
    
    func getProduct(withId id:Int) -> Product? {
        return products.first{$0.id == id}
    }
    
    func getProducts(for organization:Organization) -> [Product] {
        return products.filter{product in product.organizationID == organization.id}.sorted(){$0.name < $1.name}
    }
    
    func getSubProducts(for product:Product) -> [SubProduct] {        
        return subProducts.filter{subProduct in subProduct.productID == product.id}.sorted(){$0.name < $1.name}
    }
    
}

