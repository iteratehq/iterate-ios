//
//  PromptWindowLevelTests.swift
//  IterateTests
//

import XCTest
@testable import Iterate

final class PromptWindowLevelTests: XCTestCase {
    func testPromptWindowAppearsAboveElevatedNormalHostWindow() {
        let hostWindowLevel = UIWindow.Level.normal + 1
        let promptWindowLevel = PassthroughWindow.promptWindowLevel(above: hostWindowLevel)

        XCTAssertGreaterThan(promptWindowLevel.rawValue, hostWindowLevel.rawValue)
        XCTAssertLessThan(promptWindowLevel.rawValue, UIWindow.Level.alert.rawValue)
    }

    func testPromptWindowLevelStaysBelowAlertLevelWindows() {
        let promptWindowLevel = PassthroughWindow.promptWindowLevel(above: .alert)

        XCTAssertLessThan(promptWindowLevel.rawValue, UIWindow.Level.alert.rawValue)
    }
}
