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
        Iterate.shared.configure(apiKey: testApiKey)
        XCTAssertEqual(Iterate.shared.apiKey, testApiKey, "API key not set")
    }
    
    /// Test that setting the API key also initializes the API client
    func testConfigureSetsApiClient() {
        Iterate.shared.configure(apiKey: testApiKey)
        XCTAssertNotNil(Iterate.shared.api, "API client not set")
        XCTAssertEqual(Iterate.shared.api?.apiKey, testApiKey, "API client has incorrect API key")
    }
}
