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
    func delete(for key: StorageKeys) -> Void
    func value(for key: StorageKeys) -> String?
    func set(value: String, for key: StorageKeys) -> Void
}

/// Create a Storage namespace
struct Storage {
    
    /// Set the default shared instance of the UserDefaultsStorageEngine
    public static let shared: StorageEngine = KeychainStorageEngine()
}

enum StorageKeys: String {
    case TrackingLastUpdated = "trackingLastUpdated"
    case UserApiKey = "userApiKey"
    case UserProperties = "userProperties"
}

