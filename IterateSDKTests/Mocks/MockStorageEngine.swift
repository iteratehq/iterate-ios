//
//  MockStorageEngine.swift
//  IterateTests
//
//  Created by Michael Singleton on 1/1/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation
@testable import IterateSDK

/// Storage engine backed by in memory dictionary
class MockStorageEngine: StorageEngine {
    var storage: [StorageKeys: String?] = [:]
    
    /// Get a value from the key
    /// - Parameter key: Key to get
    func value(for key: StorageKeys) -> String? {
        storage[key] ?? nil
    }
    
    func delete(for key: StorageKeys) -> Void {
        storage[key] = nil
    }
    
    func clear() -> Void {
        delete(for: StorageKeys.UserProperties)
        delete(for: StorageKeys.UserApiKey)
        delete(for: StorageKeys.TrackingLastUpdated)
    }
    
    /// Set a value using the key
    /// - Parameters:
    ///   - key: Key to set
    ///   - value: Value to set
    func set(value: String, for key: StorageKeys) -> Void {
        storage[key] = value
    }
}
