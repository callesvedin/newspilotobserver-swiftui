import CoreData
import Newspilot
import os


class NewspilotManager {

//    static let newspilotURLPath = "newspilot.hallmedia.se"
//    static let newspilotURLPath = "bnr-hds-npp01.ad.bonniernews.se"
//    static let newspilotURLPath = "gmesnv48.gotamedia.int"
//    static let newspilotURLPath = "testnpdev3.infomaker.lan"
//    static let newspilotURLPath = "newspilot.dev.np.infomaker.io"
    static let newspilotURLPath = "demonp.infomaker.lan"
//    static let newspilotURLPath = "localhost"
//    static let newspilotURLPath = "np.tryout.infomaker.io"

    static let shared = NewspilotManager()
    
    private let newspilot: Newspilot
    private let dispatchQueue: DispatchQueue
    
    let newspilotDateFormatter:DateFormatter
    
    var queries = [EntityQuery]()


    private init() {
        let login = "infomaker"
        let password = "newspilot"

        newspilotDateFormatter = DateFormatter()
        newspilotDateFormatter.timeZone = TimeZone(identifier: "UTC")
        newspilotDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        dispatchQueue = DispatchQueue(label: "se.infomaker.NewspilotOberver.CoreDataStack")
        dispatchQueue.suspend()

        newspilot = Newspilot(server: NewspilotManager.newspilotURLPath, login:login, password: password)
        
        newspilot.addConnectionCallback {[weak weakSelf = self](connectionStatus) in
            guard let strongSelf = weakSelf else {return}
             
            switch connectionStatus {
            case .Connected:
                strongSelf.dispatchQueue.resume()
                strongSelf.loadEntities()
                NotificationCenter.default.post(
                    name: Notification.Name.DidConnect,
                    object: nil)

            case .Disconnected(let _reason):
                strongSelf.dispatchQueue.suspend()
                if let reason = _reason {
                    switch reason {
                        case .error(let errorCode, let errorMessage):
                            NotificationCenter.default.post(
                                name: Notification.Name.ConnectionFailed,
                                object: nil, userInfo:["errorMessage": errorMessage as Any, "errorCode": errorCode as Any])
                        case .ok: break
                    }
                }
            }
        }
    }

    
    func applicationWillTerminate() {
        queries.forEach { (query) in
            query.remove()
        }
    }

    
    func addQuery(withQuid quid:String, queryString:String,  queryCallback: @escaping QueryCallback) {
        dispatchQueue.async {
            self.newspilot.addQuery(quid: quid, queryString: queryString, queryCallback: queryCallback)
        }
    }
    
    
    func removeQuery(withQuid quid: String) {
        queries.removeAll() {query in query.quid == quid}
        dispatchQueue.async {
            self.newspilot.removeQuery(withQuid: quid)
        }
    }
    
    func removePagesFromCoreData() {
        CoreDataStack.shared.performBackgroundTask { (managedObjectContext) in
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch {
                    let saveError = error as NSError
                    os_log("Could not save managed context error: %@, userInfo: %@", log: .coreData, type: .error, saveError, saveError.userInfo)
                }
            }
            
            let fetchRequest: NSFetchRequest<NPEntity> = NPEntity.fetchRequest(withEntityType: .Page)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            batchDeleteRequest.resultType = .resultTypeCount
            let batchDeleteResult = try? managedObjectContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
            let deletedPages = batchDeleteResult?.result ?? 0
            os_log("Batch delete removed %ld pages", log: .coreData, type: .debug, deletedPages as! CVarArg)
            
            managedObjectContext.reset()
        }
    }
    
    
    private func loadEntities() {
        if queries.count > 0 {
            queries.forEach() {query in removeQuery(withQuid: query.quid)}
            queries.removeAll()
        }
        let queryString = """
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
        
        queries.append(EntityQuery(quid: "defaultQuery", queryString: queryString))

        let statusQuery = """
            <query type="Status" version="1.1">
                <structure>
                    <entity type="Status"/>
                </structure>
                <base-query>
                    <and>
                        <ne field="id" type="Status" value="-1"/>
                        <eq field="type" type="Status" value="5"/>
                    </and>
                </base-query>
            </query>
            """

        queries.append(EntityQuery(quid: "statusQuery", queryString: statusQuery))

        let flagQuery = """
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

        queries.append(EntityQuery(quid: "flagQuery", queryString: flagQuery))
    }
    
    func createPageQuery(withSubProduct subProduct: SubProductEntity, publicationDate: PublicationDateEntity) -> EntityQuery? {
      
        guard let product = subProduct.product else {
            os_log("Subproduct without product in createPageQuery", log: .newspilot, type: .error)
            return nil
        }
        
        let queryString = """
    <query type="Page" version="1.1">
        <structure>
            <entity type="Page"/>
        </structure>
        <base-query>
            <and>
                <eq field="product.id" type="Page" value="\(Int(product.entityId))"/>
                <ne field="preproductionType" type="Page" value="1"/>
                <eq field="publicationDate.id" type="Page" value="\(Int(publicationDate.entityId))"/>
                <eq field="subProduct.id" type="Page" value="\(Int(subProduct.entityId))"/>
            </and>
        </base-query>
    </query>
    """
        let query = EntityQuery(quid: UUID().uuidString, queryString: queryString)
        queries.append(query)
        return query
    }
    
    func createPublicationDateQuery(withProduct product: ProductEntity) -> EntityQuery? {
        guard let data = product.data,
            let json = ((try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String : AnyObject]) as [String : AnyObject]??)else {
                return nil
        }
        
        guard let dict = json, let productId = dict["id"] as? Int else {
            return nil
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.beginningOf(date: Date()) ?? Date()
        let aMonthAgo = calendar.date(byAdding: .month, value: -5, to: today, wrappingComponents: true)
        let nextYear = calendar.date(byAdding: .year, value: 1, to: today, wrappingComponents: true)
        
        guard let fromDate = aMonthAgo, let toDate = nextYear else {
            os_log("Could not create beginning and end of date for publication dates", log: .newspilot, type: .error)            
            return nil
        }
        
        let fromDateString = newspilotDateFormatter.string(from: fromDate)
        let toDateString = newspilotDateFormatter.string(from: toDate)
        
        let queryString = """
        <query type="PublicationDate" version="1.1">
            <structure>
                <entity type="PublicationDate"/>
            </structure>
            <base-query>
                <and>
                    <eq field="product.id" type="PublicationDate" value="\(productId)"/>
                    <between field="pubDate" type="PublicationDate" value1="\(fromDateString)" value2="\(toDateString)"/>
                </and>
            </base-query>
        </query>
        """
        let query = EntityQuery(quid: UUID().uuidString, queryString: queryString)
        queries.append(query)
        return query
    }
    
}
