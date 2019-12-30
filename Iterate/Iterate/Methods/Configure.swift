//
//  Configure.swift
//  Iterate
//
//  Created by Michael Singleton on 12/21/19.
//  Copyright © 2019 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// Iterate extension that adds the configure method
extension Iterate {
    
    /// Configure sets the necessary configuration properties. This should be called before any other methods.
    /// - Parameter apiKey: Your Iterate API Key, you can find this on your settings page
    public func configure(apiKey: String) {
        self.apiKey = apiKey
    }
}
