//
//  ConfigureTests.swift
//  IterateTests
//
//  Created by Michael Singleton on 12/21/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import XCTest
@testable import Iterate

/// Contains tests for the configure method of the Iterate class
class ConfigureTests: XCTestCase {
    
    /// Test that the API key is correctly set on the shared instance
    func testConfigure() {
        let client = Iterate()
        client.configure(apiKey: testApiKey)
        XCTAssertEqual(client.apiKey, testApiKey, "API key not set")
    }
    
    /// Test that setting the API key also initializes the API client
    func testConfigureSetsApiClient() {
        let client = Iterate()
        client.configure(apiKey: testApiKey)
        XCTAssertNotNil(client.api, "API client not set")
        XCTAssertEqual(client.api?.apiKey, testApiKey, "API client has incorrect API key")
    }
}
