//
//  Response.swift
//  Iterate
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// API response wrapper, this is the structure of all API responses
struct Response<ResponseType: Codable>: Codable {
    let error: String? // Legacy error handling, newer endpoints use the errors array
    let errors: [ResponseError]?
    let results: ResponseType?
}

struct ResponseError: Codable {
    let code: Int
    let message: String?
    let type: String
    let userMessage: String?
}
