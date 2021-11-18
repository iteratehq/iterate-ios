//
//  KeychainStorageEngine.swift
//  Iterate
//
//  Created by Michael Singleton on 1/1/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// Storage engine backed by the keychain
final class KeychainStorageEngine: StorageEngine {
    /// Name of service to use in the keychain
    private let Service = "com.iteratehq.sdk"
    
    /// Get a value from the key
    /// - Parameter key: Key to get
    func value(for key: StorageKeys) -> String? {
        var q = query(for: key)
        var ref: CFTypeRef?
        
        q[kSecReturnData as String] = true
        q[kSecReturnAttributes as String] = true
        if SecItemCopyMatching(q as CFDictionary, &ref) == noErr,
            let result = ref as? [String: Any],
            let data = result[kSecValueData as String] as? Data,
            let resultString = String(data: data, encoding: .utf8) {
            return resultString
        }
        
        return nil
    }
    
    /// Set a value using the key, either inserting it if it doesn't exist or updating it
    /// - Parameters:
    ///   - key: Key to set
    ///   - value: Value to set
    func set(value: String, for key: StorageKeys) -> Void {
        var q = query(for: key)
        
        guard let data = value.data(using: .utf8) else {
            return
        }

        guard SecItemCopyMatching(q as CFDictionary, nil) == noErr else {
            // Item not found, insert it
            q[kSecValueData as String] = data
            if SecItemAdd(q as CFDictionary, nil) != errSecSuccess {
                assertionFailure("Unable to add item to keychain")
            }

            return
        }
        
        // Item was found, update it
        if SecItemUpdate(q as CFDictionary, NSDictionary(dictionary: [kSecValueData: data])) != errSecSuccess {
            assertionFailure("Unable to update item to keychain")
        }
    }
    
    /// Delete the value associated with the key
    func delete(for key: StorageKeys) -> Void {
        let status = SecItemDelete(query(for: key) as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            assertionFailure("Unable to delete item to keychain")
        }
    }
    
    /// Delete all values from storage
    func clear() -> Void {
        delete(for: StorageKeys.TrackingLastUpdated)
        delete(for: StorageKeys.UserApiKey)
        delete(for: StorageKeys.UserProperties)
    }
    
    private func query(for key: StorageKeys) -> [String: Any] {
        return  [
                   kSecClass as String: kSecClassGenericPassword,
                   kSecAttrService as String: Service,
                   kSecAttrAccount as String: key.rawValue,
                   kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
                   kSecAttrSynchronizable as String: true
               ]
    }
}
