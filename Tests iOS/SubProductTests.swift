//
//  NewspilotObserver_SwiftUITests.swift
//  NewspilotObserver-SwiftUITests
//
//  Created by carl-johan.svedin on 2019-06-29.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import XCTest
@testable import NewspilotObserver_SwiftUI

class SubProductTests: XCTestCase {
        
//    override func setUp() {
//        super.setUp()
//    }
    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
    let testSettings =  """
<?xml version="1.0" encoding="UTF-8"?>
        <settings>
        <field name="part">
            <option>1</option>
            <option>2</option>
        </field>
        <field name="edition">
            <option>1</option>
            <option>2</option>
            <option>3</option>
            <option>4</option>
        </field>
        <field name="version">
            <option>1</option>
            <option>2</option>
        </field>
        <field name="sequence"/>
    </settings>
"""
    
    func testParseSettings() {
        let subProduct = SubProduct(id: 1, productId: 1, name: "TestProduct", settingsString:testSettings)
        
        let settings = subProduct.settings
        XCTAssertNotNil(settings, "Settings is nil")
        XCTAssertEqual(settings!.parts, ["1", "2"], "Parts not parsed ok")
        XCTAssertEqual(settings!.editions, ["1", "2", "3", "4"], "Editions not parsed ok")
        XCTAssertEqual(settings!.versions, ["1", "2"], "Versions not parsed ok")        
    }
    
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
