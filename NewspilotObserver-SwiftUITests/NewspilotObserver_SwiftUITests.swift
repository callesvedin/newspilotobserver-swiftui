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
        
        newspilot = Newspilot(server:"localhost", login:"infomaker", password:"newspilot")
        //        newspilot = Newspilot(server:"newspilot.dev.np.infomaker.io", login:"infomaker", password:"newspilot")
        newspilot.connect()
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
            queryAddedExpectation.fulfill()
        })
        
        pageQuery.load();
        self.wait(for: [queryAddedExpectation], timeout: 10)
        cancellable.cancel()
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
