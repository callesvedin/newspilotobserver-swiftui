import CoreData
import os

public class CoreDataStack {
    
    public static let shared = CoreDataStack()
    
    
    lazy public var managedObjectContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    private var persistentContainer: NSPersistentContainer
    private let dispatchQueue: DispatchQueue
    

    private init() {

        dispatchQueue = DispatchQueue(label: "se.infomaker.NewspilotOberver.CoreDataStack")
        dispatchQueue.suspend()

        persistentContainer = NSPersistentContainer(name: "NewspilotEntities")    
        persistentContainer.loadPersistentStores { (description, error) in
            self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            self.dispatchQueue.resume()
        }
        os_log("CoreData path: %@", log: .coreData, type: .debug, persistentContainer.persistentStoreCoordinator.persistentStores.first?.url?.absoluteString ?? "nil")        
    }
    

    public func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        dispatchQueue.async {
            self.persistentContainer.performBackgroundTask(block)
        }
    }
}
