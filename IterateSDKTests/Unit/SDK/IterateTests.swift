//
//  IterateTests.swift
//  IterateTests
//
//  Created by Michael Singleton on 12/20/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import XCTest
@testable import Iterate

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
    
    /// Test behavior of user properties with and without merging
    func testUserPropertiesBehavior() {
        let client = Iterate(storage: MockStorageEngine())
        
        // Test default overwrite behavior
        client.identify(userProperties: ["first": UserPropertyValue("John")])
        client.identify(userProperties: ["last": UserPropertyValue("Doe")])
        XCTAssertEqual(client.userProperties?.count, 1)
        XCTAssertEqual(client.userProperties?["last"]?.value as? String, "Doe")
        
        // Test explicit merge behavior
        client.identify(userProperties: ["first": UserPropertyValue("John")], mergeWithExisting: true)
        client.identify(userProperties: ["last": UserPropertyValue("Doe")], mergeWithExisting: true)
        XCTAssertEqual(client.userProperties?.count, 2)
        XCTAssertEqual(client.userProperties?["first"]?.value as? String, "John")
        XCTAssertEqual(client.userProperties?["last"]?.value as? String, "Doe")
        
        // Test overwriting with merge enabled
        client.identify(userProperties: ["first": UserPropertyValue("Jane")], mergeWithExisting: true)
        XCTAssertEqual(client.userProperties?["first"]?.value as? String, "Jane")
        XCTAssertEqual(client.userProperties?.count, 2)
        
        // Test nil handling
        client.identify(userProperties: nil)
        XCTAssertNotNil(client.userProperties)
        XCTAssertEqual(client.userProperties?.count, 2)
        
        // Test empty dict
        client.identify(userProperties: [:])
        XCTAssertNotNil(client.userProperties)
        XCTAssertEqual(client.userProperties?.count, 2)
        
        // Test different types
        client.identify(userProperties: [
            "string": UserPropertyValue("text"),
            "number": UserPropertyValue(123),
            "boolean": UserPropertyValue(true),
            "date": UserPropertyValue(Date())
        ], mergeWithExisting: true)
        XCTAssertEqual(client.userProperties?.count, 6)
        
        // Test reset
        client.reset()
        XCTAssertNil(client.userProperties)
    }
    
    /// Test behavior of response properties with and without merging
    func testResponsePropertiesBehavior() {
        let client = Iterate(storage: MockStorageEngine())
        
        // Test default overwrite behavior
        client.identify(responseProperties: ["prop1": ResponsePropertyValue("value1")])
        client.identify(responseProperties: ["prop2": ResponsePropertyValue("value2")])
        XCTAssertEqual(client.responseProperties?.count, 1)
        XCTAssertEqual(client.responseProperties?["prop2"]?.value as? String, "value2")
        
        // Test explicit merge behavior
        client.identify(responseProperties: ["prop1": ResponsePropertyValue("value1")], mergeWithExisting: true)
        client.identify(responseProperties: ["prop2": ResponsePropertyValue("value2")], mergeWithExisting: true)
        XCTAssertEqual(client.responseProperties?.count, 2)
        
        // Test different types
        client.identify(responseProperties: [
            "string": ResponsePropertyValue("text"),
            "number": ResponsePropertyValue(123),
            "boolean": ResponsePropertyValue(true),
            "date": ResponsePropertyValue(Date())
        ], mergeWithExisting: true)
        XCTAssertEqual(client.responseProperties?.count, 6)
        
        // Test overwriting with merge enabled
        client.identify(responseProperties: ["prop1": ResponsePropertyValue("new value")], mergeWithExisting: true)
        XCTAssertEqual(client.responseProperties?.count, 6)
        
        // Test nil handling
        client.identify(responseProperties: nil)
        XCTAssertNotNil(client.responseProperties)
        XCTAssertEqual(client.responseProperties?.count, 6)
        
        // Test empty dict
        client.identify(responseProperties: [:])
        XCTAssertNotNil(client.responseProperties)
        XCTAssertEqual(client.responseProperties?.count, 6)
        
        // Test reset
        client.reset()
        XCTAssertNil(client.responseProperties)
    }
}
