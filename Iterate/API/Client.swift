//
//  Client.swift
//  Iterate
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// Iterate API Client
class APIClient {
    // MARK: Properties

    /// API Host, should be https://iteratehq.com under most circumstances
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
    init(apiKey: String, apiHost: String = Iterate.DefaultAPIHost) {
        self.apiHost = apiHost
        self.apiKey = apiKey
        
        // Default to snake case
        encoder.keyEncodingStrategy = .convertToSnakeCase
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    // MARK: Request Methods (GET, POST, etc)
    
    /// Make a post request with the provided data and return the results
    /// - Parameters:
    ///   - path: Path to call
    ///   - data: Post body data
    ///   - complete: Results callback
    func post<T: Codable> (_ data: Data?, to path: Path, completion: @escaping (T?, Error?) -> Void) {
        guard var request = makeRequest(path: path) else {
            completion(nil, IterateError.invalidAPIUrl)
            return
        }
        
        request.httpMethod = "POST"
        request.httpBody = data

        performDataTask(request: request, completion: completion)
    }
    
    // MARK: Helpers
    
    /// Generate a URLRequest set with the proper content type and authentication
    /// - Parameter path: API Path to request
    func makeRequest(path: Path) -> URLRequest? {
        guard let url = URL(string: "\(apiHost)/api/v1\(path)") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    /// Create a data task from the request, run the task, handle any errors from the API and return the results
    /// - Parameters:
    ///   - request: Request to run, see the request helper method to help construct it
    ///   - complete: Results callback
    func performDataTask<T: Codable>(request: URLRequest, completion: @escaping (T?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Error calling the Iterate API: \(String(describing: error))")
                    completion(nil, IterateError.apiRequestError)
                    return
                }
                
                guard let data = data else {
                    print("Error calling the Iterate API: invalid response")
                    completion(nil, IterateError.invalidAPIResponse)
                    return
                }
                
                guard let response = try? self.decoder.decode(Response<T>.self, from: data) else {
                    print("Error calling the Iterate API: error decoding json response")
                    completion(nil, IterateError.jsonDecoding)
                    return
                }
                
                if let error = response.error {
                    print("Error calling the Iterate API: \(String(describing: error))")
                    completion(nil, IterateError.apiError(error))
                    return
                }
                
                completion(response.results, nil)
            }
        }
        
        task.resume()
    }
}
