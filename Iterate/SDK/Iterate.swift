//
//  Iterate.swift
//  Iterate
//
//  Created by Michael Singleton on 12/20/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// The Iterate class is the primary class of the SDK, the main entry point is the shared singleton property
public class Iterate {
    // MARK: Properties
    
    /// The shared singleton instance is the primary entrypoint into the Iterate iOS SDK.
    /// Unless you have uncommon needs you should use this singleton to call methods
    /// on the Iterate class.
    public static let shared = Iterate()
    
    /// Storage key used to store the user API key
    static let UserApiStorageKey = "userApiStorageKey"
    
    /// API Client, which will be initialized when the API key is
    var api: APIClient?
    
    /// Optional API host override to use when creating the API client
    var apiHost: String?
    
    /// You Iterate API Key, you can get this from your settings page
    var companyApiKey: String? {
        didSet {
            updateApiKey()
        }
    }
    
    /// The API key for a user, this is returned by the server the first time a request is made by a new user
    var userApiKey: String? {
        get {
            if cachedUserApiKey == nil {
                cachedUserApiKey = storage.get(key: Iterate.UserApiStorageKey) as? String
            }
            
            return cachedUserApiKey
        }
        set(newUserApiKey) {
            cachedUserApiKey = newUserApiKey
            storage.set(key: Iterate.UserApiStorageKey, value: newUserApiKey)
            
            updateApiKey()
        }
    }
    
    /// Storage engine for storing user data like their API key and user attributes
    var storage: StorageEngine
    
    /// Container manages the overlay window
    let container = ContainerWindowDelegate()
    
    /// Cached copy of the user API key that was loaded from UserDefaults
    private var cachedUserApiKey: String?
    
    // MARK: Init
    
    /// Initializer
    /// - Parameter storage: Storage engine to use
    init(storage: StorageEngine = Storage.shared) {
        self.storage = storage
    }
    
    // MARK: Methods
    
    /// Helper method used when calling the embed endpoint which is responsible for updating the user API key
    /// if a new one is returned
    /// - Parameters:
    ///   - context: Embed context data
    ///   - complete: Callback returning the response and error from the embed endpoint
    func embedRequest(context: EmbedContext, complete: @escaping (EmbedResponse?, Error?) -> Void) {
        api?.embed(context: context, complete: { (response, error) in
            // Update the user API key if one was returned
            if let token = response?.auth?.token {
                self.userApiKey = token
            }
            
            complete(response, error)
        })
    }
    
    /// Update the API client to use the latest API key. We prefer to use the user API key and fallback to the company key
    func updateApiKey() {
        if let apiKey = userApiKey ?? companyApiKey {
            api = APIClient(apiKey: apiKey, apiHost: apiHost ?? DefaultAPIHost)
        }
    }
}
