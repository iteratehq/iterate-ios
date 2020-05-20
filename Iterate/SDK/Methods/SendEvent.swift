//
//  SendEvent.swift
//  Iterate
//
//  Created by Michael Singleton on 5/2/20.
//  Copyright © 2020 Pickaxe LLC (DBA Iterate). All rights reserved.
//

import Foundation

/// Iterate extension that adds the sendEvent method
extension Iterate {
    
    /// Send event to determine if a survey should be shown
    /// - Parameters:
    ///   - name: Event name
    ///   - complete: optional callback with the results of the request
    public func sendEvent(name: String, complete: ((Survey?, Error?) -> Void)? = nil) {
        guard self.api != nil else {
            if let callback = complete {
                callback(nil, IterateError.invalidAPIKey)
            }
            
            return
        }
        
        var context = initCurrentContext()
        context.event = EventContext(name: name)
        embedRequest(context: context) { (response, error) in
            // TODO: Is a survey is returned, display it
            
            if let callback = complete {
                callback(response?.survey, error)
            }
        }
    }
}
