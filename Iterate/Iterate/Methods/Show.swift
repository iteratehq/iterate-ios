//
//  Show.swift
//  Iterate
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2019 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// Iterate extension that adds the show method
extension Iterate {
    
    /// Show a specific survey based on the surveyId
    /// - Parameters:
    ///   - surveyId: The id of the survey to show
    ///   - complete: Callback returning the survey that is displayed or an error
    public func show(surveyId: String, complete: (Survey?, Error?) -> Void) {
        guard self.apiKey != nil else {
            complete(nil, IterateError.invalidApiKey)
            return
        }
    }
}

