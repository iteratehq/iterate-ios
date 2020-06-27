//
//  Preview.swift
//  Iterate
//
//  Created by Michael Singleton on 6/21/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// Iterate extension that adds the preview method
extension Iterate {
    
    /// Preview processes the custom scheme url that was used to open the app and sets
    /// the preview mode to the surveyId passed in
    /// - Parameter url: The URL that opened the application
    public func preview(url: URL) {
        let result = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first(where: { $0.name == Iterate.PreviewParameter })?.value
        previewingSurveyId = result
    }
    
    /// Preview a specific survey using it's id
    /// - Parameter surveyId: The id of the survey to preview
    public func preview(surveyId: String) {
        previewingSurveyId = surveyId
    }
}
