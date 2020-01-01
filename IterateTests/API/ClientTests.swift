//
//  ClientTests.swift
//  IterateTests
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2019 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import XCTest
@testable import Iterate

class ClientTests: XCTestCase {
    func testClientEmbed() {
        let api = APIClient(apiKey: testApiKey)
        var context = EmbedContext(type: EmbedType.mobile)
        context.trigger = TriggerContext(surveyId: testManualTriggerSurvey, type: TriggerType.manual)
        
        let exp = expectation(description: "Show completion callback")
        var response: EmbedResponse?
        var error: Error?
        api.embed(context: context) { (resp, err) in
            response = resp
            error = err
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 3)
        
        XCTAssertNil(error)
        XCTAssertNotNil(response)
    }
}

