import SwiftUI
import Combine
import CoreData

class ProductStore: NSObject, ObservableObject {
    
    
    // MARK: Private Properties
//    private let persistenceManager = PersistenceManager()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<ProductEntity> = {
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]

        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataStack.shared.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private var products: [ProductEntity] {
        return fetchedResultsController.fetchedObjects ?? []
    }
    
    // MARK: Public Properties    
    let willChange = PassthroughSubject<ProductStore, Never>()
    
    // MARK: Object Lifecycle
    
    override init() {
        super.init()
        fetchProducts()
    }
   
    // MARK: Private Methods
    
    private func fetchProducts() {
        do {
            try fetchedResultsController.performFetch()
            dump(fetchedResultsController.sections)
        } catch {
            fatalError()
        }
    }
    
    func productsFor(organizationId:Int32) -> [ProductEntity] {
        return self.products.filter() {product in
            product.organization?.entityId == organizationId
        }
    }
}


// MARK: ProductStore + NSFetchedResultsControllerDelegate
extension ProductStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        willChange.send(self)
    }
}
