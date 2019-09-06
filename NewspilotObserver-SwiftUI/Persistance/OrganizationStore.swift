import SwiftUI
import Combine
import CoreData

class OrganizationStore: NSObject, ObservableObject {
       
    private lazy var fetchedResultsController: NSFetchedResultsController<OrganizationEntity> = {
        let fetchRequest: NSFetchRequest<OrganizationEntity> = OrganizationEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataStack.shared.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private var organizations: [OrganizationEntity] {
        return fetchedResultsController.fetchedObjects ?? []
    }
    
    let willChange = PassthroughSubject<OrganizationStore, Never>()
    
    // MARK: Public Properties
//    let didChange = PassthroughSubject<OrganizationStore, Never>()
    
    // MARK: Object Lifecycle
    
    override init() {
        super.init()
        fetchOrganizations()
    }
    
    // MARK: Private Methods
    
    private func fetchOrganizations() {
        do {
            try fetchedResultsController.performFetch()
            dump(fetchedResultsController.sections)
        } catch {
            fatalError()
        }
    }
    
//    public var completedTodos: [Todo] {
//        return self.todos.filter { $0.isComplete }
//    }
    
    public var allOrganizations:[OrganizationEntity] {
        return self.organizations;
    }
}


// MARK: OrganizationStore + NSFetchedResultsControllerDelegate
extension OrganizationStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        willChange.send(self)
    }
}
