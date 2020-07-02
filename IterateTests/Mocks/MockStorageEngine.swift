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
    var storage: [StorageKeys: Any?] = [:]
    
    /// Get a value from the key
    /// - Parameter key: Key to get
    func get(key: StorageKeys) -> Any? {
        storage[key] ?? nil
    }
    
    /// Set a value using the key
    /// - Parameters:
    ///   - key: Key to set
    ///   - value: Value to set
    func set(key: StorageKeys, value: Any?) -> Void {
        storage[key] = value
    }
}
