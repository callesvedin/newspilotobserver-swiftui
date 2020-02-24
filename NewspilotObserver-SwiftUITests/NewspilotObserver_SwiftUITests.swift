//
//  NewspilotObserver_SwiftUITests.swift
//  NewspilotObserver-SwiftUITests
//
//  Created by carl-johan.svedin on 2019-06-29.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import XCTest
@testable import NewspilotObserver_SwiftUI
@testable import Newspilot

class NewspilotObserver_SwiftUITests: XCTestCase {
    
    var newspilot:Newspilot!
    
    override func setUp() {
        super.setUp()
        
        newspilot = Newspilot()
        newspilot.connect(server:"newspilot.dev.np.infomaker.io", login:"infomaker", password:"newspilot")
//        newspilot.connect(server:"localhost", login:"infomaker", password:"newspilot")
        sleep(1)
        print("Is connected:\(newspilot.connected)")
        sleep(1)
        print("Is connected:\(newspilot.connected)")
        sleep(1)
        print("Is connected:\(newspilot.connected)")
        
        print("Session created: \(newspilot.sessionId)")
        XCTAssert(newspilot.sessionId > 0)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreatePublicationDateQuery() {
        let queryAddedExpectation = XCTestExpectation(description:"QueryAdded")
        
        let publicationDateQuery = PublicationDateQuery(withNewspilot: newspilot, productId: 1)
        let cancellable = publicationDateQuery.objectWillChange.sink(receiveCompletion: {completion in
            switch completion {
            case .failure(let f):
                print("Failed \(f)")
                XCTFail("Received failure")
            case .finished :
                print("Finished")
            }
        }, receiveValue: {
            print("Receiving value")
            queryAddedExpectation.fulfill()
        })
        
        publicationDateQuery.load();
        self.wait(for: [queryAddedExpectation], timeout: 5)
        cancellable.cancel()
    }
    
    func testCreatePageQuery() {
        let queryAddedExpectation = XCTestExpectation(description:"QueryAdded")
        
        let pageQuery = PageQuery(withNewspilot: newspilot, productId: 1, subProductId: 1, publicationDateId: 15597)
        let cancellable = pageQuery.objectWillChange.sink(receiveCompletion: {completion in
            switch completion {
            case .failure(let f):
                print("Failed \(f)")
                XCTFail("Received failure")
            case .finished :
                print("Finished")
            }
        }, receiveValue: {
            print("Receiving value")
            print("Backs:\(pageQuery.backs.count)")
            if (pageQuery.backs.count > 0)  {
//                do {
//                    for (backKey, pages) in pageQuery.backs {
//                        try self.writeToFile(backKey:backKey, pages: pages)
//                    }
//                } catch(let error) {
//                    print("Could not write data. Error: \(error.localizedDescription)")
//                }
                queryAddedExpectation.fulfill()
            }
        })
        
        pageQuery.load();
        self.wait(for: [queryAddedExpectation], timeout: 10)
        cancellable.cancel()
    }
    
    func testCreateStatusQuery() {
            let queryAddedExpectation = XCTestExpectation(description:"QueryAdded")
            
            let statusQuery = StatusQuery(withNewspilot: newspilot)
            let cancellable = statusQuery.objectWillChange.sink(receiveCompletion: {completion in
                switch completion {
                case .failure(let f):
                    print("Failed \(f)")
                    XCTFail("Received failure")
                case .finished :
                    print("Finished")
                }
            }, receiveValue: {
                print("Receiving value")
                print("Statuses:\(statusQuery.statuses.count)")
                if (statusQuery.statuses.count > 0)  {
//                    do {
//                          try self.write(array: statusQuery.statuses, toFile: "statuses.json")
//                    } catch(let error) {
//                        print("Could not write data. Error: \(error.localizedDescription)")
//                    }
                    queryAddedExpectation.fulfill()
                }
            })
            
            statusQuery.load();
            self.wait(for: [queryAddedExpectation], timeout: 10)
            cancellable.cancel()
        }
    
     func testCreateOrganizationQuery() {
        let queryAddedExpectation = XCTestExpectation(description:"QueryAdded")
        
        let organizationQuery = OrganizationsQuery(withNewspilot: newspilot)
        
        let cancellable = organizationQuery.objectWillChange.sink(receiveCompletion: {completion in
            switch completion {
            case .failure(let f):
                print("Failed \(f)")
                XCTFail("Received failure")
            case .finished :
                print("Finished")
            }
        }, receiveValue: {_ in
            print("Receiving value")
            print("Organizations:\(organizationQuery.organizations.count)")
            if (organizationQuery.organizations.count > 0)  {
//                do {
//                    try self.write(array: organizationQuery.organizations, toFile: "organizations.json")
//                } catch(let error) {
//                    print("Could not write data. Error: \(error.localizedDescription)")
//                }
                queryAddedExpectation.fulfill()
            }
        })
        
        organizationQuery.load();
        self.wait(for: [queryAddedExpectation], timeout: 10)
        cancellable.cancel()
        
    }
    
    func testCreateProductQuerySubProducts() {
        let queryAddedExpectation = XCTestExpectation(description:"QueryAdded")
        
        let organizationQuery = OrganizationsQuery(withNewspilot: newspilot)
        
        let cancellable = organizationQuery.objectWillChange.sink(receiveCompletion: {completion in
            switch completion {
            case .failure(let f):
                print("Failed \(f)")
                XCTFail("Received failure")
            case .finished :
                print("Finished")
            }
        }, receiveValue: {_ in
            print("Receiving value")
            print("SubProducts:\(organizationQuery.subProducts.count)")
            if (organizationQuery.subProducts.count > 0)  {
//                do {
//                    try self.write(array: organizationQuery.subProducts, toFile: "subproducts.json")
//                } catch(let error) {
//                    print("Could not write data. Error: \(error.localizedDescription)")
//                }
                queryAddedExpectation.fulfill()
            }
        })
        
        organizationQuery.load();
        self.wait(for: [queryAddedExpectation], timeout: 10)
        cancellable.cancel()
        
    }
    
    func testCreateOrganizationQueryProducts() {
        let queryAddedExpectation = XCTestExpectation(description:"QueryAdded")
        
        let organizationQuery = OrganizationsQuery(withNewspilot: newspilot)
        
        let cancellable = organizationQuery.objectWillChange.sink(receiveCompletion: {completion in
            switch completion {
            case .failure(let f):
                print("Failed \(f)")
                XCTFail("Received failure")
            case .finished :
                print("Finished")
            }
        }, receiveValue: {_ in
            print("Receiving value")
            print("Products:\(organizationQuery.products.count)")
            if (organizationQuery.products.count > 0)  {
//                do {
//                    try self.write(array: organizationQuery.products, toFile: "products.json")
//                } catch(let error) {
//                    print("Could not write data. Error: \(error.localizedDescription)")
//                }
                queryAddedExpectation.fulfill()
            }
        })
        
        organizationQuery.load();
        self.wait(for: [queryAddedExpectation], timeout: 10)
        cancellable.cancel()
        
    }
    
    func testCreateOrganizationQuerySections() {
            let queryAddedExpectation = XCTestExpectation(description:"QueryAdded")
            
            let organizationQuery = OrganizationsQuery(withNewspilot: newspilot)
            
        let cancellable = organizationQuery.objectWillChange
//            .throttle(for: 5, scheduler: DispatchQueue(label: self.debugDescription), latest:true)
            .sink(receiveCompletion: {completion in
                switch completion {
                case .failure(let f):
                    print("Failed \(f)")
                    XCTFail("Received failure")
                case .finished :
                    print("Finished")
                }
            }, receiveValue: {_ in
                print("Receiving value")
                print("Sections:\(organizationQuery.sections.count)")
                if (organizationQuery.sections.count > 0)  {
//                    do {
//                        try self.write(array: organizationQuery.sections, toFile: "sections.json")
//                    } catch(let error) {
//                        print("Could not write data. Error: \(error.localizedDescription)")
//                    }
                    queryAddedExpectation.fulfill()
                }
            })
            
            organizationQuery.load();
            self.wait(for: [queryAddedExpectation], timeout: 10)
            cancellable.cancel()
            
        }
    
    private func write<T : Codable> (array:[T], toFile file:String) throws {            
        let jsonData = try! JSONEncoder().encode(array)

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)

            //writing
            do {
                try jsonData.write(to: fileURL)
            }
            catch {/* error handling here */}
            print("Wrote:\(fileURL)")
        }
    }

    
    
    private func writeBackToFile(backKey:BackKey, pages:[Page]) throws {
        let file = "\(backKey).json" //this is the file. we will write to and read from it
        
//        let pageJsonData = try JSONSerialization.data(withJSONObject: pages, options: [.prettyPrinted])
        let pageJsonData = try! JSONEncoder().encode(pages)
//        let jsonString = String(data: jsonData, encoding: .utf8)!
//        print(jsonString)

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(file)

            //writing
            do {
                try pageJsonData.write(to: fileURL)
            }
            catch {/* error handling here */}
            print("Wrote:\(fileURL)")
        }
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
