//
//  zeg_botTests.swift
//  zeg_botTests
//
//  Created by Shane Qi on 5/9/16.
//  Copyright © 2016 Shane. All rights reserved.
//

import XCTest
@testable import zeg_bot

class zeg_botTests: XCTestCase {
	
	let jsonString = "{\"update_id\": \"719528423\",\"message\": {\"message_id\": 35454,\"from\": {\"id\": 80548625,\"first_name\": \"Shane\",\"last_name\": \"Qi\",\"username\": \"ShaneQi\"},\"chat\": {\"id\": 80548625,\"first_name\": \"Shane\",\"last_name\": \"Qi\",\"username\": \"ShaneQi\",\"type\": \"private\"},\"date\": 1462855531,\"text\": \"/学长\"}}"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
