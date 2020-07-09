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
            if let callback = complete {
                callback(response?.survey, error)
            }
            
            if let survey = response?.survey {
                // Show the survey after N seconds otherwise show immediately
                if survey.triggers?.first?.type == TriggerType.seconds {
                    DispatchQueue.main.async {
                        let seconds: Int = survey.triggers?.first?.options?.seconds ?? 0
                        Timer.scheduledTimer(withTimeInterval: Double(seconds), repeats: false) { timer in
                            self.container.showPrompt(survey)
                        }
                    }
                } else {
                    self.container.showPrompt(survey)
                }
            }
        }
    }
}
