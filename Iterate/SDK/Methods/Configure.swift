//
//  Configure.swift
//  Iterate
//
//  Created by Michael Singleton on 12/21/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// Iterate extension that adds the configure method
extension Iterate {
    
    /// Configure sets the necessary configuration properties. This should be called before any other methods.
    /// - Parameter apiKey: Your Iterate API Key, you can find this on your settings page
    public func configure(apiKey: String, apiHost: String? = DefaultAPIHost) {
        // Note: we need to set the apiHost before setting the companyApiKey
        // since updating the companyApiKey is what triggers to API client
        // to be set via a custom setter
        self.apiHost = apiHost
        
        // If we're changing the company API key to a different company API key
        // clear the user api key since it won't work for a different company
        if self.companyApiKey != nil && self.companyApiKey != apiKey {
            self.userApiKey = nil
        }
        
        self.companyApiKey = apiKey
    }
}
