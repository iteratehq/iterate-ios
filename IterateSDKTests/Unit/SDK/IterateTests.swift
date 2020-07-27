//
//  IterateTests.swift
//  IterateTests
//
//  Created by Michael Singleton on 12/20/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import XCTest
@testable import IterateSDK

/// Valid Iterate API key (suitable for use in integration tests)
let testCompanyApiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb21wYW55X2lkIjoiNWRmZTM2OGEwOWI2ZWYwMDAxYjNlNjE4IiwiaWF0IjoxNTc2OTQxMTk0fQ.QBWr2goMwOngVhi6wY9sdFAKEvBGmn-JRDKstVMFh6M"

/// Valid Iterate user API key (suitable for use in integration tests)
let testUserApiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb21wYW55X2lkIjoiNWRmZTM2OGEwOWI2ZWYwMDAxYjNlNjE4IiwidXNlcl9pZCI6IjVlMGQwNzFlM2IxMzkwMDAwMTBlMjVhMiIsImlhdCI6MTU3NzkxMjA5NH0.utTdqt32vltkWcTzS82rg3_jORqozhiTvx3RYIS_aVA"

/// Valid survey id for an event-triggered mobile survey (suitable for use in integration tests)
let testIntegrationSurvey = "5edfaeb2c591ad0001ead90d"

/// Valid event name for integration tests
let testEventName = "test-event"

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
    
    /// Test that the company API key is correctly used when the user API key isn't present
    func testCompanyApiKeyUsed() {
        let client = Iterate(storage: MockStorageEngine())
        client.companyApiKey = "COMPANY_123"
        XCTAssertEqual(client.api?.apiKey, "COMPANY_123")
    }
    
    /// Test that the user API key is correctly used when it's set
    func testNewUserApiKeyUsed() {
        let client = Iterate(storage: MockStorageEngine())
        client.companyApiKey = "COMPANY_123"
        XCTAssertEqual(client.api?.apiKey, "COMPANY_123")
        client.userApiKey = "USER_123"
        XCTAssertEqual(client.api?.apiKey, "USER_123")
    }
}
