//
//  MockStorageEngine.swift
//  IterateTests
//
//  Created by Michael Singleton on 1/1/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation
@testable import Iterate

/// Storage engine backed by in memory dictionary
class MockStorageEngine: StorageEngine {
    var storage: [String: Any?] = [:]
    
    /// Get a value from the key
    /// - Parameter key: Key to get
    func get(key: String) -> Any? {
        storage[key] ?? nil
    }
    
    /// Set a value using the key
    /// - Parameters:
    ///   - key: Key to set
    ///   - value: Value to set
    func set(key: String, value: Any?) -> Void {
        storage[key] = value
    }
}
