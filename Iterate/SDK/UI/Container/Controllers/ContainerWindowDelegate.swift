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
    var surveyViewController: SurveyViewController? {
        let containerBundle = Bundle(for: ContainerWindowDelegate.self)
        let bundleUrl = containerBundle.url(forResource: "Iterate", withExtension: "bundle")
        let bundle = Bundle(url: bundleUrl!)
        
       return UIStoryboard(
            name: "Surveys",
            bundle: bundle
        ).instantiateViewController(withIdentifier: "SurveyModalViewController") as? SurveyViewController
    }
    
    /// Holds a reference to the view controller that presents the survey
    var presentingViewController: UIViewController?
    
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
                self.containerViewController?.showPrompt(complete: {
                    Iterate.shared.api?.displayed(survey: survey, complete: { _, _ in })
                })
            }
        }
    }
        
    func showSurvey(_ survey: Survey) {
        DispatchQueue.main.async {
            // Hide the prompt
            self.containerViewController?.hidePrompt()
            
            guard let surveyViewController = self.surveyViewController else {
                return
            }
            
            // Show the survey
            surveyViewController.survey = survey
            surveyViewController.delegate = self
            self.presentingViewController = self.getPresentingViewController()
            self.presentingViewController?.present(surveyViewController, animated: true, completion: nil)
        }
    }
    
    func dismissPrompt(survey: Survey?, userInitiated: Bool) {
        if let survey = survey, userInitiated {
            Iterate.shared.api?.dismissed(survey: survey, complete: { _, _ in })
        }
        
        containerViewController?.hidePrompt(complete: {
            self.hideWindow()
        })
    }
    
    func dismissSurvey(survey: Survey?, userInitiated: Bool) {
        if let survey = survey, userInitiated {
            Iterate.shared.api?.dismissed(survey: survey, complete: { _, _ in })
        }
        
        self.presentingViewController?.dismiss(animated: true, completion: {
            self.presentingViewController = nil
            self.hideWindow()
        })
    }
    
    /// Get the currently visible view controller which we will use to modally present the survey and fall back to our container view controller
    func getPresentingViewController() -> UIViewController? {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        var visibleViewController = window?.rootViewController
        
        if visibleViewController == nil {
            return containerViewController
        }
        
        while visibleViewController?.presentedViewController != nil {
            switch visibleViewController?.presentedViewController {
                case let navigationController as UINavigationController:
                    visibleViewController = navigationController.visibleViewController
            case let tabBarController as UITabBarController:
                visibleViewController = tabBarController.selectedViewController
            default:
                visibleViewController = visibleViewController?.presentedViewController
            }
        }
        
        return visibleViewController
    }
}
