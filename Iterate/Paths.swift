//
//  Paths.swift
//  Iterate
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2019 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

typealias Path = String

/// List of all API paths used by the client, we use static members here to simulate
/// namespaces so the consumer can call: Paths.Surveys.Embed
struct Paths {
    static let Surveys = SurveyPaths()
}

/// Survey-level API paths
struct SurveyPaths {
    let Embed: Path = "/surveys/embed"
}
