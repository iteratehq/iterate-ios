//
//  ConfigureTests.swift
//  IterateTests
//
//  Created by Michael Singleton on 12/21/19.
//  Copyright © 2019 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import XCTest
@testable import Iterate


/// Contains tests for the configure method of the Iterate class
class ConfigureTests: XCTestCase {
    
    /// Test that the API key is correctly set on the shared instance
    func testConfigure() {
        let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb21wYW55X2lkIjoiNWRmZTM2OGEwOWI2ZWYwMDAxYjNlNjE4IiwiaWF0IjoxNTc2OTQxMTk0fQ.QBWr2goMwOngVhi6wY9sdFAKEvBGmn-JRDKstVMFh6M"
        Iterate.shared.configure(apiKey: apiKey)
        XCTAssertEqual(Iterate.shared.apiKey, apiKey, "API key not set")
    }
}
