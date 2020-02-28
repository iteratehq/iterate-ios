//
//  Show.swift
//  Iterate
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation
import UIKit

/// Iterate extension that adds the show method
extension Iterate {
    
    /// Show method without a callback
    /// - Parameter surveyId: The id of the survey to show
    public func show(surveyId: String) {
        show(surveyId: surveyId) { (_, _) in }
    }
    
    /// Show a specific survey based on the surveyId
    /// - Parameters:
    ///   - surveyId: The id of the survey to show
    ///   - complete: Callback returning the survey that is displayed or an error
    public func show(surveyId: String, complete: @escaping (Survey?, Error?) -> Void) {
        guard self.api != nil else {
            complete(nil, IterateError.invalidAPIKey)
            return
        }
        
        // Generate the context including the manual survey trigger
        var context = initCurrentContext()
        context.trigger = TriggerContext(surveyId: surveyId, type: TriggerType.manual)
        
        embedRequest(context: context, complete: { (response, error) in
            DispatchQueue.main.async {
                if let surveyModalViewController = UIStoryboard(
                    name: "Surveys",
                    bundle: Bundle(identifier: "com.iteratehq.Iterate")
                ).instantiateViewController(withIdentifier: "SurveyModalViewController") as? DisappearableUIViewController {
                    self.container.present(surveyModalViewController, animated: true, completion: nil)
                }
            }
            
            complete(response?.survey, error)
        })
    }
}

