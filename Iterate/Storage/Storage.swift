//
//  Storage.swift
//  Iterate
//
//  Created by Michael Singleton on 1/1/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// Protocol to represent a simple get/set storage engine
protocol StorageEngine {
    func get(key: StorageKeys) -> Any?
    func set(key: StorageKeys, value: Any?) -> Void
}

/// Create a Storage namespace
struct Storage {
    
    /// Set the default shared instance of the UserDefaultsStorageEngine
    public static let shared: StorageEngine = UserDefaultsStorageEngine()
}

enum StorageKeys: String {
    case UserApiKey = "userApiKey"
    case UserProperties = "userProperties"
}

