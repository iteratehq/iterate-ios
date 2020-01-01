//
//  IterateTests.swift
//  IterateTests
//
//  Created by Michael Singleton on 12/20/19.
//  Copyright © 2019 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import XCTest
@testable import Iterate

/// Valid Iterate API key (suitable for use in integration tests)
let testApiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb21wYW55X2lkIjoiNWRmZTM2OGEwOWI2ZWYwMDAxYjNlNjE4IiwiaWF0IjoxNTc2OTQxMTk0fQ.QBWr2goMwOngVhi6wY9sdFAKEvBGmn-JRDKstVMFh6M"

/// Valid survey id for a manually triggered mobile survey (suitable for use in integration tests)
let testManualTriggerSurvey = "5dfe369809b6ef0001b3f869"

/// Contains tests for the primary Iterate class and shared singleton object
class IterateTests: XCTestCase {
    /// Test basic initialization
    func testInit() {
        XCTAssertNoThrow(Iterate())
    }
    
    /// Test that the shared singleton is available
    func testSharedInstance() {
        XCTAssertNoThrow(Iterate.shared)
    }
}
