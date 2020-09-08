//
//  ColorExtensionTests.swift
//  NewspilotObserver-SwiftUITests
//
//  Created by carl-johan.svedin on 2019-12-13.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import XCTest
@testable import NewspilotObserver_SwiftUI


class ColorExtensionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitWithHex_NoHash() {
        let color = UIColor(hexString:"363636")
        var red = CGFloat()
        var green = CGFloat()
        var blue = CGFloat()
        let ok = color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        print("ok: \(ok) Red:\(red) Green:\(green) Blue:\(blue)")
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(red, 0.21176470588235294)
        XCTAssertEqual(green, 0.21176470588235294)
        XCTAssertEqual(blue, 0.21176470588235294)
    }

    func testInitWithHex_WithHash() {
        let color = UIColor(hexString:"#363636")
        var red = CGFloat()
        var green = CGFloat()
        var blue = CGFloat()
        let ok = color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        print("ok: \(ok) Red:\(red) Green:\(green) Blue:\(blue)")
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(red, 0.21176470588235294)
        XCTAssertEqual(green, 0.21176470588235294)
        XCTAssertEqual(blue, 0.21176470588235294)
    }

}
