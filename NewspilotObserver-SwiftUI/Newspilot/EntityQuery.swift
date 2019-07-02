import CoreData
import Newspilot
import os

class EntityQuery {
    
    let quid: String
    
    static var publicationDateFormatter:DateFormatter {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ" //2018-12-01T00:00+01:00
            return dateFormatter
    }
    
    init(quid: String, queryString: String) {
        self.quid = quid

        NewspilotManager.shared.addQuery(withQuid: quid, queryString: queryString) { (query, events) in
            // TODO check queryId
            self.process(events: events)
        }
    }

    
    func remove() {
        NewspilotManager.shared.removeQuery(withQuid: quid)        
    }
    
    
    private func process(events: [Event]) {
        
        CoreDataStack.shared.performBackgroundTask { (managedObjectContext) in
            events.forEach({ (event) in
                
                let fetchRequest: NSFetchRequest<NPEntity> = NPEntity.fetchRequest(withEntityType: event.entityType)
                fetchRequest.predicate = NSPredicate(format: "entityId==%@ AND entityType==%@", NSNumber(integerLiteral: event.entityId), event.entityType.rawValue)
                
                var entity: NPEntity? = nil
                if let entities = try? managedObjectContext.fetch(fetchRequest) {
                    if let _entity = entities.first {
                        entity = _entity
                    }
                }
                os_log("Processing event from newspilot. EntityType: %@ , EntityId: %ld", log: .newspilot, type: .debug, event.entityType.rawValue, event.entityId)
                switch event.eventType {
                    
                case .CREATE:
                    if entity == nil {
                        os_log("Enitiy is null. Creating it", log:.newspilot, type: .debug)
                        guard let _entity = NSEntityDescription.insertNewObject(forEntityName: "\(event.entityType.rawValue)Entity", into: managedObjectContext) as? NPEntity else {
                            os_log("Could not create it", log:.newspilot, type: .debug)
                            return
                        }
                        entity = _entity
                    }
                    entity?.entityId = Int32(event.entityId)
                    entity?.entityType = event.entityType.rawValue
                    entity?.data = try? JSONSerialization.data(withJSONObject: event.values, options: []) as Data
                    self.fixStructure(entity: entity, values: event.values, managedObjectContext: managedObjectContext)
                    
                case .CHANGE:
                    if let _entity = entity {
                        _entity.data = try? JSONSerialization.data(withJSONObject: event.values, options: []) as Data
                        self.fixStructure(entity: _entity, values: event.values, managedObjectContext: managedObjectContext)
                    }
                    
                case .REMOVE:
                    if let _entity = entity {
                        managedObjectContext.delete(_entity)
                    }
                    return
                }                
            })
            
            try? managedObjectContext.save()
        }
    }
    
    
    private func fixStructure(entity: NPEntity?, values: [String : AnyObject], managedObjectContext: NSManagedObjectContext) {

        if let organization = entity as? OrganizationEntity {
            organization.name = values["name"] as? String
        }
            
        else if let product = entity as? ProductEntity {
            product.name = values["name"] as? String
            product.shortName = values["short_name"] as? String
            if let organizationId = values["organization_id"] as? Int {
                let organizationRequest = NPEntity.fetchRequest(withEntityIdentifier: EntityIdentifier(id: organizationId, type: .Organization))
                let organizations = try? managedObjectContext.fetch(organizationRequest)
                let organization = organizations?.first as? OrganizationEntity
            
                product.organization = organization
            }
        }
        else if let publicationDate = entity as? PublicationDateEntity {
            publicationDate.name = values["name"] as? String
            let pubDateString = values["pub_date"] as? String
            
            publicationDate.pubDate = pubDateString != nil ? EntityQuery.publicationDateFormatter.date(from: pubDateString!) as Date? : nil
            publicationDate.issuenumber = values["issuenumber"] as? String
            
            if let productId = values["product_id"] as? Int {
                let productRequest = NPEntity.fetchRequest(withEntityIdentifier: EntityIdentifier(id:productId, type: .Product))
                if let products = try? managedObjectContext.fetch(productRequest) {
                    let product = products.first as! ProductEntity
                    publicationDate.product = product
                }
            }
        }
        else if let subProduct = entity as? SubProductEntity {
            subProduct.name = values["name"] as? String
            if let productId = values["product_id"] as? Int {
                let productRequest = NPEntity.fetchRequest(withEntityIdentifier: EntityIdentifier(id:productId, type: .Product))
                if let products = try? managedObjectContext.fetch(productRequest), !products.isEmpty {
                    let product = products.first as! ProductEntity
                    subProduct.product = product
                }
            }
        }

        else if let section = entity as? SectionEntity {
            section.name = values["name"] as? String
        }

        else if let status = entity as? StatusEntity {
            status.name = values["name"] as? String
            status.color = values["color"] as? Double ?? 0
        }
        else if let flag = entity as? EntityFlagEntity {
            if let fillInt = values["fill_space"] as? Int {
                flag.fillSpace = fillInt == 1
            }else{
                flag.fillSpace = false
            }
            if let base64 = values["off_symbol"] as? String {
                flag.offSymbol = createImageData(fromBase64:base64)
            }
            if let base64 = values["on_symbol"] as? String {
                flag.onSymbol = createImageData(fromBase64:base64)
            }
            if let sortKey = values["sort_key"] as? Int32 {
                flag.sortKey = sortKey
            }

        }
        else if let page = entity as? PageEntity {
            page.name = values["name"] as? String
            page.back = "Del \(values["part"] as? String ?? "")"
            page.part = values["part"] as? String
            page.firstPagin = values["first_pagin"] as? Double ?? 0
            page.documentName = values["document_name"] as? String
            page.edition = values["edition"] as? String
            page.version = values["version"] as? String
            
            if let dateString = values["created_date"] as? String {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ" //2018-07-13T08:28:02.908+02:00
                let date = formatter.date(from: dateString)
                page.createdDate = date as Date?
            }
            if let sectionId = values["section_id"] as? Int {
                let sectionRequest = NPEntity.fetchRequest(withEntityIdentifier: EntityIdentifier(id: sectionId, type: .Section))
                if let entities = try? managedObjectContext.fetch(sectionRequest), let section = entities.first as? SectionEntity {
                    page.section = section
                }
            }
            
            if let statusId = values["status"] as? Int {
                let statusRequest = NPEntity.fetchRequest(withEntityIdentifier: EntityIdentifier(id: statusId, type: .Status))
                if let entities = try? managedObjectContext.fetch(statusRequest), let status = entities.first as? StatusEntity {
                    page.status = status
                }
            }

            if let flagIds = values["flags"] as? [Int] {
                if page.flags != nil {
                    page.removeFromFlags(page.flags!)                    
                }
                flagIds.forEach({flagId in
                    let flagRequest = NPEntity.fetchRequest(withEntityIdentifier: EntityIdentifier(id: flagId, type: .EntityFlag))
                    if let entities = try? managedObjectContext.fetch(flagRequest), let flag = entities.first as? EntityFlagEntity {
                        page.addToFlags(flag)
                    }

                })
            }
            if let publicationDateId = values["publication_date_id"] as? Int {
                let publicationDateRequest = NPEntity.fetchRequest(withEntityIdentifier: EntityIdentifier(id: publicationDateId, type: .PublicationDate))
                if let entities = try? managedObjectContext.fetch(publicationDateRequest),
                    let publicationDate = entities.first as? PublicationDateEntity {
                    page.publicationDate = publicationDate
                }
            }
        }

    }
    
    func createImageData(fromBase64 _base64:String?) -> Data? {
        guard let base64 = _base64 else {
            return nil;
        }
        
        let dataDecoded : Data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters)!
        return dataDecoded as Data
    }
}

