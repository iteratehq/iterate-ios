//
//  Errors.swift
//  Iterate
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

public enum IterateError: Error, Equatable {
    case apiError(String)
    case apiRequestError
    case invalidAPIKey
    case invalidAPIResponse
    case invalidAPIUrl
    case jsonDecoding
    case jsonEncoding
}
