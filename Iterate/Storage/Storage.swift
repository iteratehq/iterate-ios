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
    func get(key: String) -> Any?
    func set(key: String, value: Any?) -> Void
}

/// Create a Storage namespace
struct Storage {
    
    /// Set the default shared instance of the UserDefaultsStorageEngine
    public static let shared: StorageEngine = UserDefaultsStorageEngine()
}
