//
//  ShowIntegrationTests.swift
//  IterateTests
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import XCTest
@testable import Iterate

/// Contains tests for the show method of the Iterate class
class ShowIntegrationTests: XCTestCase {
    
    /// Test that the show method is called correctly
    func testShowRequiresApiKey() {
        var error: Error?
        let exp = expectation(description: "Show completion callback")
        let iterateInstance = Iterate()
        iterateInstance.show(surveyId: testManualTriggerSurvey) { (survey, e) in
            error = e
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 3)
        XCTAssertEqual(error as? IterateError, IterateError.invalidAPIKey)
    }
    
    /// Test that the show method correctly returns a survey
    func testShowReturnsASurvey() {
        var error: Error?
        var survey: Survey?
        let exp = expectation(description: "Show completion callback")
        let iterateInstance = Iterate()
        iterateInstance.configure(apiKey: testApiKey)
        iterateInstance.show(surveyId: testManualTriggerSurvey) { (surveyCallback, errorCallback) in
            survey = surveyCallback
            error = errorCallback
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 3)
        
        XCTAssertNil(error)
        XCTAssertEqual(survey?.id, testManualTriggerSurvey)
    }
}
