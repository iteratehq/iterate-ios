//
//  Context.swift
//  Iterate
//
//  Created by Michael Singleton on 1/1/20.
//  Copyright © 2019 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// Iterate extension that adds the initCurrentContext method
extension Iterate {
    
    /// Generate a embed context that represents the current state of the user.
    /// In the future this may set the current 'view' the user is on, how long they've been
    /// in the app, etc. Anything that may be used for targeting.
    func initCurrentContext() -> EmbedContext {
        return EmbedContext(targeting: nil, trigger: nil, type: EmbedType.mobile)
    }
}

