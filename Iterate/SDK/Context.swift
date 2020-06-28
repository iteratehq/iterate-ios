//
//  Context.swift
//  Iterate
//
//  Created by Michael Singleton on 1/1/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// Iterate extension that adds the initCurrentContext method
extension Iterate {
    
    /// Generate a embed context that represents the current state of the user.
    /// In the future this may set the current 'view' the user is on, how long they've been
    /// in the app, etc. Anything that may be used for targeting.
    func initCurrentContext() -> EmbedContext {
        // Include the url scheme of the app so we can generate a url to preview the survey
        var app: AppContext?
        if let urlScheme = Iterate.shared.urlScheme {
            app = AppContext(urlScheme: urlScheme, version: Iterate.Version)
        }
        
        // Include the survey id we're previewing
        var targeting: TargetingContext?
        if let previewingSurveyId = previewingSurveyId {
            targeting = TargetingContext(frequency: TargetingContextFrequency.always, surveyId: previewingSurveyId)
        }
        
        return EmbedContext(app: app, targeting: targeting, trigger: nil, type: EmbedType.mobile)
    }
}

