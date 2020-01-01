//
//  UserDefaultsStorageEngine.swift
//  Iterate
//
//  Created by Michael Singleton on 1/1/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// Storage engine backed by UserDefaults
class UserDefaultsStorageEngine: StorageEngine {
    /// Prefix used on all keys to ensure ours are unique and don't conflict with any others
    let KeyPrefix = "com.iteratehq.sdk."
    
    /// Get a value from the key
    /// - Parameter key: Key to get
    func get(key: String) -> Any? {
        UserDefaults.standard.object(forKey: "\(KeyPrefix)\(key)")
    }
    
    /// Set a value using the key
    /// - Parameters:
    ///   - key: Key to set
    ///   - value: Value to set
    func set(key: String, value: Any?) -> Void {
        UserDefaults.standard.set(value, forKey: "\(KeyPrefix)\(key)")
    }
}
