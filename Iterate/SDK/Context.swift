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
        // TODO: Remove. Setting this to be in preview mode so we can force the surveys to show
        // up until we have a proper preview-mode mechanism.
        let targeting = TargetingContext(frequency: TargetingContextFrequency.always, surveyId: "5ec54a4857d68f0104c1e97d")
        
        return EmbedContext(targeting: targeting, trigger: nil, type: EmbedType.mobile)
    }
}

