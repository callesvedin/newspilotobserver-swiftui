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

class OrganizationsQuery :  ObservableObject {
    
    private var newspilotManager:NewspilotManager    
    @Published var organizations:[Organization] = []
    @Published var products:[Product] = []
    @Published var subProducts:[SubProduct] = []
    //    private var sections:[Section] = []
    var cancellableSubscriber:Cancellable?
    
    
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
                        <!--entity parent="product.id" type="Section"/-->
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
            os_log("Values %@",log:.newspilot, type:.debug, event.values)
            do {
                let data = try JSONSerialization.data(withJSONObject: event.values, options: [])
                let decoder = JSONDecoder()
                switch event.eventType {
                case .CREATE:
                    switch event.entityType {
                    case .Organization:
                        
                        let organization = try decoder.decode(Organization.self, from: data)
                        print("We got an organization with the name \(organization.name)")
                        self.organizations.append(organization)
                        let organizationProducts = products.filter({product in product.organizationID == organization.id})
                        organization.products.append(contentsOf: organizationProducts)
                    case .Product:
                        
                        let product = try decoder.decode(Product.self, from: data)
                        print("We got an product with the name \(product.name)")
                        if let organization = self.organizations.first(where: {organization in product.id == organization.id}) {
                            organization.products.append(product)
                        }
                        products.append(product)
                    case .SubProduct:
                        let subProduct = try decoder.decode(SubProduct.self, from: data)
                        print("We got an product with the name \(subProduct.name)")
                        
                        subProducts.append(subProduct)
                        
                    default:
                        print("Got event entity type not handled:\(event.entityType)")
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
                        
                    default:
                        print("Can not change \(event.entityType)")                        
                    }
                case .REMOVE:
                    switch (event.entityType) {
                    case .Organization:
                        organizations.removeAll(where:{$0.id == event.entityId})
                    case .Product:
                        products.removeAll(where:{$0.id == event.entityId})
                    case .SubProduct:
                        subProducts.removeAll(where:{$0.id == event.entityId})
                    default:
                        print("Can not remove \(event.entityType)")
                        
                    }
                default:
                    os_log("Unhandled event in OrganizationQuery", log: .newspilot, type:.error)
                    
                }
            }catch(let error) {
                print("Could not decode Organization. \(error)")
            }
            
        })
    }
    
    
    func getOrganizations() -> [Organization] {
        return organizations
    }
    
    func getProduct(withId id:Int) -> Product? {
        return products.first{$0.id == id}
    }
    
    func getProducts(for organization:Organization) -> [Product] {
        return products.filter{product in product.organizationID == organization.id}
    }
    
    func getSubProducts(for product:Product) -> [SubProduct] {
        return subProducts.filter{subProduct in subProduct.productID == product.id}
    }

}

