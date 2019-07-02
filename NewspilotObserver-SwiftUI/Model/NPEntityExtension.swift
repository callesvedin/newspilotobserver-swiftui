import CoreData
import Newspilot


extension NPEntity {
 
    @nonobjc public class func fetchRequest(withEntityType entityType: EntityType, predicate: NSPredicate? = nil) -> NSFetchRequest<NPEntity> {
        
        let fetchRequest: NSFetchRequest<NPEntity> = NSFetchRequest<NPEntity>(entityName: "\(entityType.rawValue)Entity")

        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "entityType==%@", entityType.rawValue))
        if let predicate = predicate {
            predicates.append(predicate)
        }
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        switch entityType {
        case .Organization:
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]

        case .SubProduct:
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]
            
        case .Product:
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "organization.name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare)),
                NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
            ]
            
        case .Page:
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "back", ascending: true, selector: #selector(NSString.caseInsensitiveCompare)),
                NSSortDescriptor(key: "firstPagin", ascending: true)
            ]
            fetchRequest.includesSubentities = true

        case .EntityFlag:
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortKey", ascending: false)]
        default:
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "entityId", ascending: true)]
        }

        return fetchRequest
    }
    
    
    @nonobjc public class func fetchRequest(withEntityIdentifier entityIdentifier: EntityIdentifier) -> NSFetchRequest<NPEntity> {
        let fetchRequest: NSFetchRequest<NPEntity> =  NSFetchRequest<NPEntity>(entityName: "\(entityIdentifier.type.rawValue)Entity")
        fetchRequest.predicate = NSPredicate(format: "entityType==%@ AND entityId==%@", entityIdentifier.type.rawValue, NSNumber(value: entityIdentifier.id))
        return fetchRequest
    }
    
    
    public func npEntityType() -> EntityType {
        willAccessValue(forKey: "entityType")
        defer {
            didAccessValue(forKey: "entityType")
        }
        return EntityType(rawValue: self.entityType!)!
    }
}
