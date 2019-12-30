//
//  Client.swift
//  Iterate
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2019 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// Iterate API Client
struct APIClient {
    // MARK: Properties

    /// API Host, should be https://iteratehq.com/api/v1 under most circumstances
    let apiHost: String
    
    /// API Key, you can find this in your Iterate dashboard
    let apiKey: String
    
    /// JSON Encoder
    let encoder = JSONEncoder()
    
    /// JSON Decoder
    let decoder = JSONDecoder()
    
    // MARK: Initializers
    
    /// Initializer
    /// - Parameters:
    ///   - apiKey: Iterate API key
    ///   - apiHost: API Host
    init(apiKey: String, apiHost: String = "https://iteratehq.com/api/v1") {
        self.apiHost = apiHost
        self.apiKey = apiKey
        
        // Default to snake case
        encoder.keyEncodingStrategy = .convertToSnakeCase
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    // MARK: Helpers
    
    /// Generate a URLRequest set with the proper content type and authentication
    /// - Parameter path: API Path to request
    func request(path: Path) -> URLRequest? {
        guard let url = URL(string: "\(apiHost)\(path)") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/javascript", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        return request
    }
}
