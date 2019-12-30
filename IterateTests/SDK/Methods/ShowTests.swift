//
//  ShowTests.swift
//  IterateTests
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2019 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import XCTest
@testable import Iterate

/// Contains tests for the show method of the Iterate class
class ShowTests: XCTestCase {
    
    /// Test that the show method is called correctly
    func testShowRequiresApiKey() {
        var error: Error?
        let exp = expectation(description: "Show completion callback")
        let iterateInstance = Iterate()
        iterateInstance.show(surveyId: "") { (survey, e) in
            error = e
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 3)
        XCTAssertEqual(error as? IterateError, IterateError.invalidAPIKey)
    }
}
