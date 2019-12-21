//
//  IterateTests.swift
//  IterateTests
//
//  Created by Michael Singleton on 12/20/19.
//  Copyright © 2019 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import XCTest
@testable import Iterate


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
}
