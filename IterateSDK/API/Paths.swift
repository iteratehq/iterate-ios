//
//  Paths.swift
//  Iterate
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

typealias Path = String

/// List of all API paths used by the client, we use static members here to simulate
/// namespaces so the consumer can call: Paths.Surveys.Embed
struct Paths {
    static let surveys = SurveyPaths()
}

/// Survey-level API paths
struct SurveyPaths {
    func displayed(surveyId: String) -> Path { "/surveys/\(surveyId)/displayed" }
    func dismissed(surveyId: String) -> Path { "/surveys/\(surveyId)/dismiss" }
    let embed: Path = "/surveys/embed"
}
