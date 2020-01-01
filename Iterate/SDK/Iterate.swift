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
    
    /// The shared singleton instance is the primary entrypoint into the Iterate iOS SDK.
    /// Unless you have uncommon needs you should use this singleton to call methods
    /// on the Iterate class.
    public static let shared = Iterate()
    
    /// You Iterate API Key, you can get this from your settings page
    var apiKey: String? {
        didSet {
            // Initialize the API client when the apiKey is set
            if let apiKey = apiKey {
                api = APIClient(apiKey: apiKey)
            }
        }
    }
    
    /// API Client, which will be initialized when the API key is
    var api: APIClient?
}
