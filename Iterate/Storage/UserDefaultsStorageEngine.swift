//
//  UserDefaultsStorageEngine.swift
//  Iterate
//
//  Created by Michael Singleton on 1/1/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// Storage engine backed by UserDefaults
final class UserDefaultsStorageEngine: StorageEngine {
    /// Prefix used on all keys to ensure ours are unique and don't conflict with any others
    private let KeyPrefix = "com.iteratehq.sdk."
    
    /// Get a value from the key
    /// - Parameter key: Key to get
    func get(key: StorageKeys) -> Any? {
        UserDefaults.standard.object(forKey: "\(KeyPrefix)\(key.rawValue)")
    }
    
    /// Set a value using the key
    /// - Parameters:
    ///   - key: Key to set
    ///   - value: Value to set
    func set(key: StorageKeys, value: Any?) -> Void {
        UserDefaults.standard.set(value, forKey: "\(KeyPrefix)\(key.rawValue)")
    }
}
