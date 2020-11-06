//
//  EmbedEndpoint.swift
//  Iterate
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// Embed response
struct EmbedResponse: Codable {
    let auth: EmbedAuth?
    let survey: Survey?
    let tracking: TrackingContext?
}

/// Embed auth, a token is returned when embed is requested with a company auth token and not a user auth token.
/// When this is present, we'll save the user auth token and update the api token on the client to this one
struct EmbedAuth: Codable {
    let token: String
}

/// APIClient extension that adds the embed endpoint method
extension APIClient {
    /// Embed API endpoint
    /// - Parameter context: Contains all data about the context of the embed call (device type, triggers, etc)
    /// - Parameter complete: Results callback
    func embed(context: EmbedContext, completion: @escaping (EmbedResponse?, Error?) -> Void) {
        guard let data = try? encoder.encode(context) else {
            completion(nil, IterateError.jsonEncoding)
            return
        }
        
        post(data, to: Paths.surveys.embed, completion: completion)
    }
}
