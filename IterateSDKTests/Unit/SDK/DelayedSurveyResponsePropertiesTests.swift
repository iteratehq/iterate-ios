//
//  DelayedSurveyResponsePropertiesTests.swift
//  IterateTests
//
//  Created by Iterate on 2024-07-03.
//  Copyright © 2024 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import XCTest
@testable import Iterate

class DelayedSurveyResponsePropertiesTests: XCTestCase {
    
    // Test that response properties are captured at the time sendEvent is called
    func testResponsePropertiesCapturedAtSendEvent() {
        let iterate = Iterate(storage: MockStorageEngine())
        
        // Set initial response properties
        let initialProperties: ResponseProperties = [
            "initial": ResponsePropertyValue("value")
        ]
        iterate.identify(responseProperties: initialProperties)
        
        // Create a mock API client to simulate the embed request
        class MockAPIClient: APIClient {
            var embeddedSurvey: Survey?
            var capturedProperties: ResponseProperties?
            
            init() {
                super.init(apiKey: "test_key", apiHost: "https://test.com")
            }
            
            override func embed(context: EmbedContext, completion: @escaping (EmbedResponse?, Error?) -> Void) {
                // Create a test survey
                let survey = Survey()
                
                // Create a response with the survey
                let response = EmbedResponse(auth: nil, survey: survey, tracking: nil)
                
                // Call the completion handler
                completion(response, nil)
                
                // Store the survey for assertions
                self.embeddedSurvey = survey
                self.capturedProperties = survey.capturedResponseProperties
            }
        }
        
        // Set up the mock API client
        let mockClient = MockAPIClient()
        iterate.api = mockClient
        
        // Change the global response properties BEFORE sending the event
        iterate.identify(responseProperties: initialProperties)
        
        // Send the event (this should capture the current response properties)
        let expectation = self.expectation(description: "Send event completed")
        iterate.sendEvent(name: "test_event") { (_, _) in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        // Change the global response properties AFTER sending the event
        let updatedProperties: ResponseProperties = [
            "updated": ResponsePropertyValue("newValue")
        ]
        iterate.identify(responseProperties: updatedProperties)
        
        // Verify the survey has the original properties
        XCTAssertNotNil(mockClient.embeddedSurvey)
        XCTAssertNotNil(mockClient.capturedProperties)
        XCTAssertEqual(mockClient.capturedProperties?.count, 1)
        XCTAssertEqual("\(mockClient.capturedProperties?["initial"]?.value ?? "")", "value")
        XCTAssertNil(mockClient.capturedProperties?["updated"])
    }
} 
