//
//  ShowIntegrationTests.swift
//  IterateTests
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import XCTest
@testable import IterateSDK

/// Contains tests for the show method of the Iterate class
class SendEventIntegrationTests: XCTestCase {
    
    /// Test that the show method is called correctly
    func testSendEventRequiresApiKey() {
        var error: Error?
        let exp = expectation(description: "Show completion callback")
        let iterateInstance = Iterate(storage: MockStorageEngine())
        iterateInstance.sendEvent(name: testEventName) { (survey, e) in
            error = e
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10)
        XCTAssertEqual(error as? IterateError, IterateError.invalidAPIKey)
    }
    
    /// Test that the show method correctly returns a survey
    func testSendEventReturnsASurvey() {
        var error: Error?
        var survey: Survey?
        let exp = expectation(description: "Show completion callback")
        let iterateInstance = Iterate(storage: MockStorageEngine())
        iterateInstance.configure(apiKey: testCompanyApiKey)
        iterateInstance.preview(surveyId: testIntegrationSurvey)
        iterateInstance.sendEvent(name: testEventName) { (surveyCallback, errorCallback) in
            survey = surveyCallback
            error = errorCallback
            
            exp.fulfill()
        }

        waitForExpectations(timeout: 10)

        XCTAssertNil(error)
        XCTAssertEqual(survey?.id, testIntegrationSurvey)
    }
    
    /// Test that the show method correctly returns a survey
    func testSendEventSetsUserApiKey() {
        let exp = expectation(description: "Show completion callback")
        let iterateInstance = Iterate(storage: MockStorageEngine())
        iterateInstance.configure(apiKey: testCompanyApiKey)
        XCTAssertEqual(iterateInstance.api?.apiKey, testCompanyApiKey)
        
        // Calling embed with a company API key will cause a user API key to be returned
        // (we are testing that the new user key is saved correctly)
        iterateInstance.sendEvent(name: testEventName) { (surveyCallback, errorCallback) in
            exp.fulfill()
        }
        waitForExpectations(timeout: 10)
        XCTAssertNotNil(iterateInstance.userApiKey)
        XCTAssertNotEqual(iterateInstance.api?.apiKey, testCompanyApiKey)
    }
}
