//
//  ContainerWindowDelegate.swift
//  Iterate
//
//  Created by Michael Singleton on 6/9/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit

class ContainerWindowDelegate {
    var window: ContainerWindow?
    var containerViewController: ContainerViewController? {
        window?.rootViewController as? ContainerViewController
    }
    
    /// Show the window
    func showWindow(survey: Survey) {
        if window == nil {
            window = ContainerWindow(survey: survey, delegate: self)
        }
        
        window?.isHidden = false
    }
    
    /// Hide the window
    func hideWindow() {
        window?.isHidden = true
        window = nil
    }
    
    func showPrompt(_ survey: Survey) {
        // Only show the survey if we have a valid prompt
        if let _ = survey.prompt?.message,
            let _ = survey.prompt?.buttonText {
    
            DispatchQueue.main.async {
                self.showWindow(survey: survey)
                self.containerViewController?.showPrompt(survey)
            }
        }
    }
        
    func showSurvey(_ survey: Survey) {
        DispatchQueue.main.async {
            self.containerViewController?.showSurvey(survey)
        }
    }
    
    func dismiss() {
        // TODO: Make API call to dismissed
        
        hideWindow()
    }
}
